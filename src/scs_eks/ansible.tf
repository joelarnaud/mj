############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_ansible" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
    namespace = "kube-system"
  }
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role" "scs_eks_role_ansible" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces", "serviceaccounts"]
    verbs      = ["get", "list", "watch"]
  }
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_ansible" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ansible"
    namespace = "kube-system"
  }
  subject {
    kind      = "Group"
    name      = "ansible"
    namespace = "kube-system"
  }
  depends_on = [module.scs_aws_eks]
}