variable "group_tag" {
  type        = map(string)
  description = "Tags to select the resource group targeted by the scan"
  default = {
    Terraform   = "true"
  }
}

variable "rules_package" {
  type        = list(string)
  description = "Rules package ARN"
  default = ["arn:aws:inspector:us-east-1:316112463485:rulespackage/0-PmNV0Tcd"]
}

variable "assessment_name" {
  type = string
  description = "Name of the Inspector Scan"
}

variable "config_number" {
  type        = string
  description = "Number for the inspector assessment"
}
