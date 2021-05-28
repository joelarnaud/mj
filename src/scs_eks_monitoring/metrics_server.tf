############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_metricsserver" {
  metadata {
    name = "metrics-server"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:role/scs_metricsserver_for_pods_${var.scs_workload}_${var.cluster_number}"
    }
    namespace = "kube-system"
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "scs_eks_role_aggregated_metrics_reader" {
  metadata {
    name = "system:aggregated-metrics-reader"
    labels = {
      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["nodes","pods"]
    verbs      = ["get","list","watch"]
  }
}

resource "kubernetes_cluster_role" "scs_eks_role_metrics_server" {
  metadata {
    name = "system:metrics-server"
  }
  rule {
    api_groups = [""]
    resources  = ["pods","nodes","nodes/stats","namespaces","configmaps"]
    verbs      = ["get","list","watch"]
  }
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_auth_delegator" {
  metadata {
    name = "metrics-server:system:auth-delegator"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_metricsserver]
}

resource "kubernetes_role_binding" "scs_eks_role_binding_auth_reader" {
  metadata {
    name = "metrics-server-auth-reader"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_metricsserver]
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_metric_server" {
  metadata {
    name = "system:metrics-server"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:metrics-server"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_metricsserver]
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_auth_reader" {
  metadata {
    name = "metrics-server-auth-reader"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-auth-reader"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "extension-apiserver-authentication-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_metricsserver]
}
#################
# K8S Ressource #
#################

resource "kubernetes_api_service" "scs_cluster_metricserver_api_service" {
  metadata {
    name = "v1beta1.metrics.k8s.io"
  }
  spec {
    service {
      name = "metrics-server"
      namespace = "kube-system"
    }
    group = "metrics.k8s.io"
    version = "v1beta1"
    insecure_skip_tls_verify = true
    group_priority_minimum = 100
    version_priority = 100
  }
}

resource "kubernetes_deployment" "scs_cluster_metricsserver_deployment"{
  metadata {
    name = "metrics-server"
    namespace = "kube-system"
    labels = {
      "k8s-app" = "metrics-server"
    }
  }

  spec {
    selector {
      match_labels = {
        "k8s-app" = "metrics-server"
      }
    }

    template {
      metadata {
        name = "metrics-server"
        labels = {
          "k8s-app" = "metrics-server"
        }
      }
      spec {
        volume {
          name = "tmp-dir"
          empty_dir {
          }
        }
        container {
          name = "metrics-server"
          image = var.metrics_server_image
          image_pull_policy = "IfNotPresent"
          args = ["--cert-dir=/tmp","--secure-port=4443"]
          port {
            container_port = 4443
            name = "main-port"
            protocol = "TCP"
          }
          security_context {
            read_only_root_filesystem = true
            run_as_non_root = true
            run_as_user = 1000
          }
          volume_mount {
            mount_path = "/tmp"
            name = "tmp-dir"
          }
      }
        automount_service_account_token = true
        service_account_name = "metrics-server"
      }
    }
  }
  timeouts {
    create = "25m"
    delete = "25m"
  }
}

resource "kubernetes_service" "scs_metricsserver_service" {
  metadata {
    name = "metrics-server"
    namespace = "kube-system"
    labels = {
      "kubernetes.io/name" = "Metrics-server"
      "kubernetes.io/cluster-service" = "true"
    }
  }
  spec {
    port {
      port = 443
      protocol = "TCP"
      target_port = "main-port"
    }
    selector = {
      "k8s-app" = "metrics-server"
    }
  }
}

###########
# AWS IAM #
###########
data "aws_iam_policy_document" "scs_metricsserver_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${replace(kubernetes_service_account.scs_service_account_metricsserver.id,"/",":")}"]
      variable = "${substr(var.eks_oidc_issuer_url, 8, length(var.eks_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:oidc-provider/${substr(var.eks_oidc_issuer_url, 8, length(var.eks_oidc_issuer_url))}"]
    }
  }
}

resource "aws_iam_role" "scs_metricsserver_role_for_eks_pod_001" {
  name = "scs_metricsserver_for_pods_${var.scs_workload}_${var.cluster_number}"

  assume_role_policy = data.aws_iam_policy_document.scs_metricsserver_role_for_eks_pod_document.json

  tags = {
    tag-key = "tag-value"
  }
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_metricsserver" {
  statement {
    effect    = "Allow"
    actions   = [
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
}

module "iam_policy_aws_metricsserver" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"
  name        = "AWS_metricsserver_EKS__${var.cluster_number}"
  path        = "/"
  description = "Needed rights to list logs groups in cloudwatch"
  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_metricsserver.json
}

resource "aws_iam_role_policy_attachment" "scs_metricsserver_role_for_eks_pod_001_attachement" {
  role       =  aws_iam_role.scs_metricsserver_role_for_eks_pod_001.name
  policy_arn =  module.iam_policy_aws_metricsserver.arn
}

