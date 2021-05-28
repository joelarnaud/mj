############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_fluentd" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:role/scs_fluentd_for_pods_${var.scs_workload}_${var.cluster_number}"
    }
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    }
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "scs_eks_role_fluentd" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods","pods/logs"]
    verbs      = ["get", "list","watch"]
  }
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_fluentd" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_fluentd]
}

data "aws_caller_identity" "scs_current_identity" {}

#################
# K8S Ressource #
#################
resource "kubernetes_config_map" "scs_fluentd_configmap" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd-configmap"
    }
  }

  data = {
    "kubernetes.conf" = file("${path.module}/kubernetes.conf")
  }
}

resource "kubernetes_daemonset" "scs_fluentd_daemonset"{
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
      "k8s-app" = "fluentd"
    }
  }
  spec{
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
        }
        annotations = {
          configHash = "8915de4cf9c3551a8dc74c0137a3e83569d28c71044b0359c2578d2e0461825"
        }
      }
      spec {
        container {
          name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
          # image = "fluent/fluentd-kubernetes-daemonset:v1-debian-elasticsearch"
          image = "fluent/fluentd-kubernetes-daemonset:v1.9-debian-elasticsearch6-1"
          image_pull_policy = "Always"
          env {
            name = "FLUENT_ELASTICSEARCH_HOST"
            value = data.aws_elasticsearch_domain.scs_elk.endpoint
          }
          env {
            name = "FLUENT_ELASTICSEARCH_PORT"
            value = "443"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_SCHEME"
            value = "https"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_LOGSTASH_INDEX_NAME"
            value = "logstash-eks-${var.scs_workload}-${var.scs_environment}-${var.cluster_number}"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_LOGSTASH_PREFIX"
            value = "logstash-eks-${var.scs_workload}-${var.scs_environment}-${var.cluster_number}"
          }
          env {
            name = "FLUENT_CONTAINER_TAIL_EXCLUDE_PATH"
            value = "/var/log/containers/*fluentd*.log"
          }
          resources {
            limits {
              memory = "400Mi"
            }
            requests {
              cpu = "100m"
              memory = "200Mi"
            }
          }
          volume_mount {
            mount_path = "/var/log"
            name = "varlog"
          }
          volume_mount {
            mount_path = "/var/lib/docker/containers"
            name = "varlibdockercontainers"
            read_only = true
          }
          volume_mount {
            mount_path = "/fluentd/etc/kubernetes.conf"
            name = "fluentd-config"
            sub_path = "kubernetes.conf"
          }
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "fluentd-config"
          config_map {
            name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
          }
        }
        automount_service_account_token = true
        service_account_name = "scs-aws-${var.scs_workload}-${var.scs_environment}-fluentd"
        termination_grace_period_seconds = "40"
      }
    }
  }

  timeouts {
    create = "25m"
    delete = "25m"
  }

}

###########
# AWS IAM #
###########
data "aws_iam_policy_document" "scs_fluentd_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${replace(kubernetes_service_account.scs_service_account_fluentd.id,"/",":")}"]
      variable = "${substr(var.eks_oidc_issuer_url, 8, length(var.eks_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:oidc-provider/${substr(var.eks_oidc_issuer_url, 8, length(var.eks_oidc_issuer_url))}"]
    }
  }
}

resource "aws_iam_role" "scs_fluentd_role_for_eks_pod_001" {
  name = "scs_fluentd_for_pods_${var.scs_workload}_${var.cluster_number}"

  assume_role_policy = data.aws_iam_policy_document.scs_fluentd_role_for_eks_pod_document.json

  tags = {
    tag-key = "tag-value"
  }
}

data "aws_region" "scs_current_region" {
  # Fetch current region
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_fluentd" {
  statement {
    effect    = "Allow"
    actions   = [
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
}

module "iam_policy_aws_fluentd" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"
  name        = "AWS_Fluentd_EKS__${var.cluster_number}"
  path        = "/"
  description = "Needed rights to list logs groups in cloudwatch"
  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_fluentd.json
}

resource "aws_iam_role_policy_attachment" "scs_fluentd_role_for_eks_pod_001_attachement" {
  role       =  aws_iam_role.scs_fluentd_role_for_eks_pod_001.name
  policy_arn =  module.iam_policy_aws_fluentd.arn
}

#############################################################################
# Temporaire en attendant la fonctionnalité du module IAM                   #
# ( https://github.com/terraform-aws-modules/terraform-aws-iam/pull/37 )    #
# supprimer lorsque prêt et intégrer via le module.                         #
#                                                                           #
# BUG!                                                                      #
# https://github.com/terraform-providers/terraform-provider-aws/issues/10104#
# FIXME                                                                     #
#############################################################################

locals {
  # ca-central-1
  # via
  # echo | openssl s_client -connect oidc.eks.ca-central-1.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}'
  eks-oidc-thumbprint = "1c8b5245e80a6b7a0e8bf5ffdab032273d7d5df1"
}


