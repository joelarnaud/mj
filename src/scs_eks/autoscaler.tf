############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_cluster_autoscaler" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:role/scs_cluster_autoscaler_role_for_eks_pod_${var.cluster_number}"
    }
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    }
    namespace = "kube-system"
  }

  automount_service_account_token = true
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role" "scs_eks_role_luster_autoscaler" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["events","endpoints"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/eviction"]
    verbs      = ["create"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs      = ["get","update"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["watch","list","get","update"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods","services","replicationcontrollers","persistentvolumeclaims","persistentvolumes"]
    verbs      = ["watch","list","get"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["replicasets","daemonsets"]
    verbs      = ["watch","list","get"]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["watch","list"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets","replicasets", "daemonsets"]
    verbs      = ["watch","list","get"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses","csinodes"]
    verbs      = ["watch","list","get"]
  }
  rule {
    api_groups = ["batch", "extensions"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch", "patch"]
  }
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_role" "scs_eks_role_cluster_autoscaler_role" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler-role"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler-role"
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
    namespace = "kube-system"
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    verbs          = ["create","get"]
  }
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cluster-autoscaler-status"]
    verbs          = ["delete","get","update"]
  }
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_cluster_autoscaler" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_cluster_autoscaler]
}

resource "kubernetes_role_binding" "scs_eks_role_binding_autoscaler" {
  metadata {
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler-role"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    namespace = "kube-system"
  }
  depends_on = [module.scs_aws_eks]
}

##################
# K8S Ressources #
##################
resource "kubernetes_deployment" "scs_cluster_autoscaler_deployment"{
  metadata {
    name = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
    }
  }

  spec{
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
        }
      }

      spec {
        container {
          name = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
          image = var.scs_cluster_autoscaler_version
          resources {
            limits {
              cpu = "100m"
              memory = "300Mi"
            }
            requests {
              cpu = "100m"
              memory = "300Mi"
            }
          }
          command = ["./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${module.scs_aws_eks.cluster_id}"
          ]

          env {
            name = "AWS_REGION"
            value = data.aws_region.scs_current_region.name
          }
          volume_mount {
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
            name = "ssl-certs"
            read_only = true
          }
          image_pull_policy = "Always"
        }

        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }
        automount_service_account_token = true
        service_account_name = "scs-aws-${var.scs_workload}-${var.scs_environment}-cluster-autoscaler"
      }
    }
  }

  timeouts {
    create = "25m"
    delete = "25m"
  }

  depends_on = [module.scs_aws_eks]
}

###########
# AWS IAM #
###########
data "aws_iam_policy_document" "scs_cluster_autoscaler_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${replace(kubernetes_service_account.scs_service_account_cluster_autoscaler.id,"/",":")}"]
      variable = "${substr(module.scs_aws_eks.cluster_oidc_issuer_url, 8, length(module.scs_aws_eks.cluster_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:oidc-provider/${substr(module.scs_aws_eks.cluster_oidc_issuer_url, 8, length(module.scs_aws_eks.cluster_oidc_issuer_url))}"]
    }
  }
}

resource "aws_iam_role" "scs_cluster_autoscaler_role_for_eks_pod_001" {
  name = "scs_cluster_autoscaler_role_for_eks_pod_${var.cluster_number}"

  assume_role_policy = data.aws_iam_policy_document.scs_cluster_autoscaler_role_for_eks_pod_document.json

  tags = {
    tag-key = "tag-value"
  }
  depends_on = [module.iam_policy_aws_cluster_autoscaler]
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_cluster_autoscaler" {
  statement {
    effect    = "Allow"
    actions   = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations"
    ]
    resources = ["*"]
  }
}

module "iam_policy_aws_cluster_autoscaler" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "AWS_CLUSTER_AUTOSCALER_EKS_${var.cluster_number}"
  path        = "/"
  description = "Needed rights for the EKS cluster autoscaler"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_cluster_autoscaler.json
}

resource "aws_iam_role_policy_attachment" "scs_cluster_autoscaler_role_for_eks_pod_001_attachement" {
  role       = aws_iam_role.scs_cluster_autoscaler_role_for_eks_pod_001.name
  policy_arn = module.iam_policy_aws_cluster_autoscaler.arn
}
