###############################################################################
# GLOBAL EKS MONITORING VAR
###############################################################################
variable "scs_workload" {
  type        = string
  description = "The workload name to use for every intenal ressource. Ex : corpo, ag, ac ..."
}

variable "scs_environment" {
  type        = string
  description = "The workload environment to use for every intenal ressource. Ex : dev, pro, lab"
  default     = "dev"
}

variable "cluster_number" {
  type        = string
  description = "Number of the cluster"
}

variable "eks_oidc_issuer_url" {
  type        = string
  description = "Open ID Connector issuer URL of the EKS cluster"
}

variable "elk_domain" {
  description = "Elastic Search domain name"
}

variable "prom_node_exporter_version" {
  description = "Version of helm chart prometheus_node_exporter ( default = 1.0.1 )"
  default = "1.0.1"
}

variable "metrics_server_image" {
  description = "Image to use for metrics server"
  default = "k8s.gcr.io/metrics-server/metrics-server:v0.3.7"

}