variable "vpc_id" {
  description = "VPC id where the instance will be created"
}

variable "subnet_ids" {
  description = "subnet ids where the instance will have access"
}

variable "endpoint_authorized_cidr" {
  description = "CIDR authorized to connect to prometheus endpoint"
}

variable "promxy_authorized_cidr" {
  description = "CIDR authorized to connect to prometheus proxy"
}

variable "ssh_authorized_cidr" {
  description = "CIDR authorized to connect to SSH"
  default     = []
}

variable "ami_id" {
  description = "AMI ID of SSQ prometheus"
  default     = "ami-04572eaba0d994d2c"
}

variable "zone_id" {
  description = "Route 53 unique id"
}

variable "ssh_allowed_security_group_ids" {
  description = "List of security group id to allowed to ssh prometheus"
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
  description = "Instance type to use for EC2 prometheus"
  default     = "t3.medium"
}

variable "prometheus_port" {
  type        = string
  description = "Prometheus http web port"
  default     = "9090"
}

variable "blackbox_port" {
  type        = string
  description = "Prometheus Blackbox http web port"
  default     = "9115"
}

variable "pushgateway_port" {
  type        = string
  description = "Prometheus Push Gateway http web port"
  default     = "9091"
}

variable "promxy_port" {
  type        = string
  description = "Prometheus Proxy http port"
  default     = "8082"
}

variable "disk_size" {
  description = "Prometheus DB Disk Size in GiB"
  default     = "40"
}

variable "prometheus1_az" {
  description = "Selected AZ for prometheus instances to launch"
  default     = "ca-central-1a"
 }

variable "prometheus2_az" {
   description = "Selected AZ for prometheus instances to launch"
   default     = "ca-central-1b"
}


variable "eks_worker_security_group_id" {
  description = "EKS Worker security group id to allow prometheus to scrape metrics"
  default = null
}