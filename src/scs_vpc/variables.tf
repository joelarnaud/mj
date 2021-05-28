###############################################################################
# GLOBAL
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

variable "scs_vpc_number" {
  type        = string
  description = "The suffix to use for every intenal ressource."
  default     = "001"
}

variable "scs_vpc_cidr" {
  type        = string
  description = ""
}

variable "scs_internal_ssq_ips" {
  type        = string
  description = "The internal SSQ Classless inter-domain routing (CIDR)"
  default     = "10.0.0.0/8"
}

# Plage AOV
variable "scs_aov_ip" {
  type        = string
  description = "Always On VPN for all SSQ IP"
  default     = "172.27.64.0/18"
}

variable "scs_private_subnets" {
  type        = list(string)
  description = "Private subnet range. Generally : [\"10.XXX.0.0/21\", \"10.XXX.8.0/21\", \"10.XXX.16.0/21\"]"
  default     = []
}

variable "scs_public_subnets" {
  type        = list(string)
  description = "Public subnet range. Generally : [\"10.XXX.128.0/21\", \"10.XXX.136.0/21\", \"10.XXX.144.0/21\"]"
  default     = []
}

variable "scs_intra_subnets" {
  type        = list(string)
  description = "Intra subnet range. Generally : [\"10.XXX.224.0/21\", \"10.XXX.232.0/21\", \"10.XXX.240.0/21\"]"
  default     = []
}

variable "scs_database_subnets" {
  type        = list(string)
  description = "Database subnet range."
  default     = []
}

variable "scs_vpc_transit_gateway_attach" {
  type = bool
  description = "Attach vpc to the transit gateway (connects with on-prem and more)"
  default = false
}
###############################################################################
# TAGGING
###############################################################################
variable "global_tags" {
  type        = map(string)
  description = "Generic tags for resources"
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "scs_vpc_tags" {
  type        = map(string)
  description = "Generic tags for vpc"
  default = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Private subnet tags"
   # To enable alb-ingress-controller feature set this value and set your cluster name :
   # "kubernetes.io/role/internal-elb" = "1", "kubernetes.io/cluster/change_me_for_eks_cluster_name" = "shared"
  default = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Public subnet tags"
  # To enable alb-ingress-controller feature set this value and set your cluster name :
  # "kubernetes.io/role/elb" = "1", "kubernetes.io/cluster/change_me_for_eks_cluster_name" = "shared"
  default = {}
}

variable "vpc_tgw_attachement_tags" {
  type        = map(string)
  description = "VPC attachement tags"
  default = {
    Name = "scs_aws_vpc_tgw_attachement"
  }
}


variable "azs" {
  type        = list(string)
  description = "A list of availability zones names or ids in the region."
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}

variable "ssq_local_dns_servers" {
  description = "IPs of ssq.local DC"
  default = [
    "10.3.42.1",
    "10.3.125.1",
    "10.3.125.1",
    "10.160.1.19",
    "10.165.1.1",
    "10.3.4.119"
  ]
}
