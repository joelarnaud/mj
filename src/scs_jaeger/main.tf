resource "kubernetes_namespace" "scs_jaeger_ns" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "scs_jaeger_all_in_one" {
  name       = "jaeger-${var.namespace_name}"
  repository = "https://repo.ssqti.ca/repository/helm-releases/"
  chart      = "jaeger"
  version    = "0.45.0"
  namespace  = kubernetes_namespace.scs_jaeger_ns.metadata[0].name
  values = [
    <<EOT
query:
  service:
    type: "NodePort"
    port: 16686
  ingress:
    enabled: true
    hosts:
      - jaeger.${var.domain_name}
    annotations: {
      kubernetes.io/ingress.class: "alb",
      alb.ingress.kubernetes.io/listen-ports: "[{\"HTTP\":80}]",
      alb.ingress.kubernetes.io/scheme: "internal",
      external-dns.alpha.kubernetes.io/alias:  "true",
      external-dns.alpha.kubernetes.io/hostname: "jaeger.${var.domain_name}"
  }
    EOT
  ]
}

