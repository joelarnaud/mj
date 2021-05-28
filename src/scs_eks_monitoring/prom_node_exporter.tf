########
# HELM #
########

resource "helm_release" "prom_node_exporter" {
  name       = "prom-node-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-node-exporter"
  namespace = "kube-system"
  version    = var.prom_node_exporter_version
}

############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_prom_node_export" {
  metadata {
    name = "prom-node-export"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "scs_eks_role_prom_node_export" {
  metadata {
    name = "prom-node-export"
    labels = {
      "app.kubernetes.io/name" = "prom-node-export"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["nodes","nodes/proxy","services","endpoints","pods"]
    verbs      = ["get","list","watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get","list","watch"]
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs      = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_prom_node_export" {
  metadata {
    name = "prom-node-export"
    labels = {
      "app.kubernetes.io/name" = "prom-node-export"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prom-node-export"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "prom-node-export"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_prom_node_export]
}