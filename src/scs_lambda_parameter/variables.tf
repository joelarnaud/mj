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
  description = "Version de la lambda compliance-parameter"
  default     = "0.0.1"
}

variable "scs-lambda-name" {
  type        = string
  description = "Name"
  default     = "compliance"
}