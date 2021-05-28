variable "authorized_cidr" {
  description = "CIDR authorized to connect to jump box"
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

variable "vpc_id" {
  description = "VPC id where the jumb box will be created"
}

variable "subnet_ids" {
  description = "subnet ids where the jumb box will have access"
}

variable "zone_id" {
  description = "Route 53 unique id"
}

variable "iam_instance_profile" {
  description = "IAM EC2 profile for the instance"
  default     = ""
}

variable "ami_id" {
  description = "AMI ID of SSQ Bastion release"
  default     = "ami-04e2641d8b55a10ef"
}

variable "bastion_name" {
  description = "Override default bastion name"
  default     = "bastion"
}

variable "volume_size" {
  description = "Volume size of the root FS"
  default = "10"
}
