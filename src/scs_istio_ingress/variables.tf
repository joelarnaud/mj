variable "namespace_name" {
  type        = string
  description = "The namespace where ingress is deployed"
  default = "istio-system"
}

variable "name" {
  type        = string
  description = "The ingress identifier"
  default = "default"
}

variable "istio_ingress_controller_role_arn" {
  description = "Arn of istio ingress controller"
  type = string
}

variable "internal" {
  type        = bool
  description = "flag for internal/public facing load balancer"
  default = true
}

variable "negociation_policy" {
  type        = string
  description = "The ingress TLS policy"
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "Arn of the ssl certificate attached to th NLB"
  default = ""
}
