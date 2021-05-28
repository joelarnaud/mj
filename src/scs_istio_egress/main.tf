
resource "helm_release" "scs_istio_egress" {
  name       = "istio-egress-${var.name}"
  repository = "https://repo.ssqti.ca/repository/helm-releases/"
  chart      = "istio-egress"
  version    = "1.1.0"
  namespace  = var.namespace_name
}
