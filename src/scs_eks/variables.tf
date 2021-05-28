###############################################################################
# GLOBAL EKS VAR
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

variable "cluster_version" {
  type        = string
  description = "Kubernetes version to use for the EKS cluster."
  default = "1.16"
}

variable "worker_ami_name_filter" {
  type        = string
  description = "Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster_version' is used."
  default = "amazon-eks-node-1.17-v20210414"
}

variable "worker_groups_instances" {
  description = "The list of instance to be created"
  type = list(object({
    instance_type = string
    kubelet_extra_args = string
    spot_price = string
  }))
}

###############################################################################
# TAGGING
###############################################################################
variable "global_tags" {
  type        = map(string)
  description = "Generic tags for resources"
}

###############################################################################
# IAM
###############################################################################

variable "scs_aws_authenticator_assumed_role_arn" {
  type        = string
  description = "ARN of the role assumed by the aws authenticator"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

###############################################################################
# VPC VARIABLES
###############################################################################

variable "scs_vpc_private_subnets" {
  type        = list(string)
  description = "List of the VPC private subnets"
}

variable "scs_vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "scs_private_access_cidr" {
  type    = list(string)
  description = "List of ip cidr allowed to connect to the API"
}

variable "allowed_security_group_ids" {
  type    = list(string)
  description = "List of security group id to allowed on workers"
}

###############################################################################
# HELM VARIABLES
###############################################################################
variable "node_termination_handler_version" {
  description = "Version of helm chart node-termination-handler ( default = 0.7.3 )"
  default = "0.7.3"
}

###############################################################################
# DEPLOYMENT VARIABLES
###############################################################################
variable "external_dns_version" {
  description = "Version of external-dns container image ( default = v0.7.0 )"
  default = "v0.7.0"
}

variable "scs_cluster_autoscaler_version" {
  description = "Full path image of the cluster-autoscaler to use"
  default = "k8s.gcr.io/autoscaling/cluster-autoscaler:v1.16.6"
}


###############################################################################
# Istio
###############################################################################

variable "istio_enabled" {
  description = "Flag to enable istio in cluster"
  type = bool
  default = false
}


variable "istio_namespace" {
  description = "Namespace where istio is installed"
  default = "istio-system"
}
