/*
#
# Variables
#
*/
variable "schedule" {
  type = string
  description = "Schedule used to trigger the lambda"
}

variable "scs_lambda_version" {
  type        = string
  description = "Version de la lambda ecr-scan"
  default     = "0.0.1"
}