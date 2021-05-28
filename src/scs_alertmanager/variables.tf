variable "vpc_id" {
  description = "VPC id where the instance will be created"
}

variable "subnet_ids" {
  description = "subnet ids where the instance will have access"
}

variable "ami_id" {
  description = "AMI ID of Alertmanager"
  default     = "ami-05c36bc233c5005d3"
}

variable "zone_id" {
  description = "Route 53 unique id"
}

variable "endpoint_authorized_cidr" {
  description = "CIDR authorized to connect to alertmanager endpoint"
}

variable "cluster_authorized_cidr" {
  description = "CIDR authorized to connect to alertmanager peering"
}

variable "dashboard_authorized_cidr" {
  description = "CIDR authorized to connect to alertmanager karma dashboard"
}

variable "ssh_authorized_cidr" {
  description = "CIDR authorized to connect to SSH"
  default     = []
}

variable "ssh_allowed_security_group_ids" {
  description = "List of security group id to allowed to ssh alertmanager"
  type        = list(string)
  default     = []
}

variable "scs_environment" {
  type        = string
  description = "The workload environment to use for every intenal ressource. Ex : dev, pro, lab"
  default     = "dev"
}

variable "scs_workload" {
  type        = string
  description = "The workload name to use for every intenal ressource. Ex : corpo, ag, ac ..."
}

variable "scs_vpc_number" {
  type = string
  description = "vpc number (lab only)"
  default = "002"
}

variable "instance_type" {
  type        = string
  description = "Instnace type to use for EC2 alertmanager"
  default     = "t3.small"
}

variable "instance_count" {
  type        = string
  description = "How many EC2 alertmanager instance"
  default     = "3"
}

variable "alertmanager_port" {
  type        = string
  description = "Alertmanager http web port"
  default     = "9093"
}

variable "alertmanager_cluster_port" {
  type        = string
  description = "Alertmanager cluster peering port"
  default     = "9094"
}

variable "dashboard_port" {
  type        = string
  description = "Karma Alertmanager dashboard web port"
  default     = "8080"
}