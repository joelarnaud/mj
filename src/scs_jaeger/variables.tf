variable "namespace_name" {
  type        = string
  description = "The namespace where ingress is deployed"
  default = "observability"
}

variable "domain_name" {
  type        = string
  description = "The domain name used by jaeger ui"
}
