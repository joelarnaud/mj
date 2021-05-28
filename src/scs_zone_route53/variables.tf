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

variable "scs_vpc_ids" {
  type        = list
  description = "The list of vpc Ids."
  default     = []
}

variable "scs_vpc_number" {
  type = string
  description = "vpc number (lab only)"
  default = "002"
}

###############################################################################
# IAM
###############################################################################

variable "account_admin_role" {
  description = "Account admin role arn"
}