resource "helm_release" "scs_istio_ingress" {
  name       = "istio-ingress-${var.name}"
  repository = "https://repo.ssqti.ca/repository/helm-releases/"
  chart      = "istio-ingress"
  version    = "1.1.1"
  namespace  = var.namespace_name

  values = [
    <<EOT
gateways:
  istio-ingressgateway:
    serviceAccountAnnotations: {
      eks.amazonaws.com/role-arn: "${var.istio_ingress_controller_role_arn}"
    }
    serviceAnnotations: {
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb",
      service.beta.kubernetes.io/aws-load-balancer-internal: "${var.internal}",
      service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy: "${var.negociation_policy}",
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert : "${var.ssl_certificate_arn}",
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https",
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
    }
    EOT
  ]
}
