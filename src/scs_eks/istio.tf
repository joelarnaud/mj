
module "scs_eks_istio" {
  source = "../scs_istio"
  count = var.istio_enabled ? 1 : 0

  cluster_oidc_issuer_url =  module.scs_aws_eks.cluster_oidc_issuer_url
  namespace_name = var.istio_namespace
}