variable "namespace_name" {
  type        = string
  description = "The namespace where istio egress is deployed"
  default = "istio-system"
}

variable "name" {
  type        = string
  description = "The egress identifier"
  default = "default"
}

