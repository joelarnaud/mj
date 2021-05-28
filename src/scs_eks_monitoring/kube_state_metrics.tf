############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_kubestatemetrics" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "scs_eks_role_kubestatemetrics" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps","secrets","nodes","pods","services","resourcequotas","replicationcontrollers","limitranges","persistentvolumeclaims","persistentvolumes","namespaces","endpoints"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["daemonsets","deployments","replicasets","ingresses"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets","daemonsets","deployments","replicasets"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs","cronjobs"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
  rule {
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
    verbs      = ["create"]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses","volumeattachments"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations","validatingwebhookconfigurations"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
    verbs      = ["list","watch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["list","watch"]
  }
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_kubestatemetrics" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_kubestatemetrics]
}

#################
# K8S Ressource #
#################
resource "kubernetes_deployment" "scs_cluster_kubestatemetrics_deployment"{
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    namespace = "kube-system"
    labels = {
      "app" = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    selector {
      match_labels = {
        "app" = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        container {
          name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
          image = "quay.io/coreos/kube-state-metrics:v1.9.7"
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }
            initial_delay_seconds = "5"
            timeout_seconds = "5"
          }
          port {
            container_port = 8080
            name = "http-metrics"
          }
          port {
            container_port = 8081
            name = "telemetry"
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "8081"
            }
            initial_delay_seconds = "5"
            timeout_seconds = "5"
          }
          security_context {
            run_as_user = "65534"
          }

      }
        automount_service_account_token = true
        service_account_name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
      }
    }
  }
  timeouts {
    create = "25m"
    delete = "25m"
  }
}

resource "kubernetes_service" "scs_kubestatemetrics_service" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    namespace = "kube-system"
    labels = {
      "app" = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    }
  }
  spec {
    type = "NodePort"
    port {
      port = 8080
      name = "http-metrics"
    }
    port {
      port = 8081
      name = "telemetry"
    }
    selector = {
      app = "scs-aws-${var.scs_workload}-${var.scs_environment}-kubestatemetrics"
    }
  }
}

