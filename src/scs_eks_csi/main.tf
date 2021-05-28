# EFS Daemonset
resource "kubernetes_daemonset" "efs_csi_node" {
  metadata {
    name      = "efs-csi-node"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        app = "efs-csi-node"
      }
    }
    template {
      metadata {
        labels = {
          app = "efs-csi-node"
        }
      }

      spec {
        host_network = true
        toleration {
          key = "CriticalAddonsOnly"
          operator = "Exists"
        }
        container {
          image = "amazon/aws-efs-csi-driver:latest"
          name  = "efs-plugin"
          security_context {
            privileged = true
          }
          args = [
            "--endpoint=$(CSI_ENDPOINT)",
            "--logtostderr",
            "--v=5"
          ]
          env {
            name = "CSI_ENDPOINT"
            value = "unix:/csi/csi.sock"
          }
          volume_mount {
            mount_path = "/var/lib/kubelet"
            name = "kubelet-dir"
            mount_propagation = "Bidirectional"
          }
          volume_mount {
            mount_path = "/csi"
            name = "plugin-dir"
          }
          port {
            container_port = 9809
            name = "healthz"
            protocol = "TCP"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }
            initial_delay_seconds = 10
            timeout_seconds = 3
            period_seconds = 2
            failure_threshold = 5
          }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
        container {
          name = "csi-driver-registrar"
          image = "quay.io/k8scsi/csi-node-driver-registrar:v1.1.0"
          args = [
            "--csi-address=$(ADDRESS)",
            "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)",
            "--v=5"
          ]
          env {
            name = "ADDRESS"
            value = "/csi/csi.sock"
          }
          env {
            name = "DRIVER_REG_SOCK_PATH"
            value = "/var/lib/kubelet/plugins/efs.csi.aws.com/csi.sock"
          }
          env {
            name = "KUBE_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          volume_mount {
            mount_path = "/csi"
            name = "plugin-dir"
          }
          volume_mount {
            mount_path = "/registration"
            name = "registration-dir"
          }
        }
        container {
          name = "liveness-probe"
          image_pull_policy = "Always"
          image = "quay.io/k8scsi/livenessprobe:v1.1.0"
          args = [
            "--csi-address=/csi/csi.sock",
            "--health-port=9809"
          ]
          volume_mount {
            mount_path = "/csi"
            name = "plugin-dir"
          }
        }
        volume {
          name = "kubelet-dir"
          host_path {
            path = "/var/lib/kubelet"
            type = "Directory"
          }
        }
        volume {
          name = "registration-dir"
          host_path {
            path = "/var/lib/kubelet/plugins_registry/"
            type = "Directory"
          }
        }
        volume {
          name = "plugin-dir"
          host_path {
            path = "/var/lib/kubelet/plugins/efs.csi.aws.com/"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}

# EFS CSI DRIVER
resource "kubernetes_csi_driver" "efs_csi" {
  metadata {
    name = "efs.csi.aws.com"
  }
  spec {
    attach_required        = false
  }
}