variable "scs_workload" {
  type        = string
  description = "The workload name to use for every intenal ressource. Ex : corpo, ag, ac ..."
}

variable "scs_environment" {
  type        = string
  description = "The workload environment to use for every intenal ressource. Ex : pro"
  default     = "pro"
}

variable "cluster_number" {
  type        = string
  description = "Number of the cluster"
}

variable "eks_oidc_issuer_url" {
  type        = string
  description = "Open ID Connector issuer URL of the EKS cluster"
}

variable "external_dns_version" {
  description = "Version of external-dns container image ( default = v0.7.0 )"
  default = "v0.7.0"
}

variable "shared_account_number" {
  description = "scs-aws-shared account number"
  default = "433887757690"
}
