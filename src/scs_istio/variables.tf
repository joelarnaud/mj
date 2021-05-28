variable "namespace_name" {
  type        = string
  description = "The namespace where ingress is deployed"
  default = "istio-system"
}

variable "name" {
  type        = string
  description = "The module name in case of multiple utlisation in the same account"
  default = "default"
}


variable "cluster_oidc_issuer_url" {
  type        = string
  description = "kubernetes cluster oidc issuer"
}
