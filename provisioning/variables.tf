###############################################################################
# SCS_AMAZONMQ RESOURCE
###############################################################################

variable "broker_name" {
  description = "(Required) Middle part of the name of the broker. Name will be scs-aws-`BROKERRNAME`-`BROKERNUMBER`. Must contain only alphanumeric characters and hyphens."
  type = string
  default = "scs-aws-test-001"
}

variable "admin_username" {
  description = "(Required) Username of the admin user."
  type = string
  default = "admin"
}

variable "admin_password" {
  description = "(Required) Password of the admin user. It must be 12 to 250 characters long, at least 4 unique characters, and must not contain commas."
  type = string
  default = "benevatest1234567890"
}

variable "application_username" {
  description = "(Required) Username of the application user."
  type = string
  default = "user"
}

variable "application_password" {
  description = "(Required) Password of the application user. It must be 12 to 250 characters long, at least 4 unique characters, and must not contain commas."
  type = string
  default = "benevatest1234567890"
}

###############################################################################
# SCS_AMAZONMQ NETWORK / NETWORK SECURITY
###############################################################################

variable "allowed_protocols" {
  description = "(Required) List of protocols for which inbound connections are allowed. Supported: AMQP (tcp/5671), CONSOLE (tcp/8162), MQTT (tcp/8883), STOMP (tcp/61614), OpenWire (tcp/61617) and WebSocket (tcp/61619)."
  type = list(string)
  default = []
}

###############################################################################
# TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "(Required) A map of tags to assign to the resource."
  default = {}
}

###############################################################################
# SCS_VPC
###############################################################################

variable "scs_vpc_cidr" {
  type        = string
  description = ""
  default = "10.137.2.0/23"
}

variable "scs_private_subnets" { 
  type = list(string)
  description = ""
  default = ["10.137.2.0/25", "10.137.2.128/25", "10.137.3.0/26"]
}

variable "scs_public_subnets" {
  type = list(string)
  description = ""
  default = ["10.137.3.64/26", "10.137.3.128/26"]
}

variable "scs_workload" {
  type    = string
  default = "lab"
}

variable "scs_environment" {
  type    = string
  default = "dev"
}

variable "scs_vpc_number" {
  type    = string
  default = "002"
}

###############################################################################
# SCS_ZONE_ROUTE53
###############################################################################

# IAM
variable "account_admin_role" {
  description = "Account admin role arn"
  default = ""
}

###############################################################################
# SCS_ALERTMANAGER
###############################################################################
variable "endpoint_authorized_cidr" {
  description = "CIDR authorized to connect to alertmanager endpoint"
  default = []
}

variable "cluster_authorized_cidr" {
  description = "CIDR authorized to connect to alertmanager peering"
  default = []
}

variable "dashboard_authorized_cidr" {
  description = "CIDR authorized to connect to alertmanager karma dashboard"
  default = []
}

###############################################################################
# SCS_ECR
###############################################################################
variable "ecr_repo_name" {
  description = "Ecr repository name. Ex : scs/ca/ssq/ac/tiragebd"
  default = "scs/ca/ssq/ac/test1"
}

# BASTION
###############################################################################

variable "authorized_cidr" {
  description = "CIDR authorized to connect to jump box"
  default = ["0.0.0.0/0"]
}

###############################################################################
# ELASTICACHE RESSOURCE
###############################################################################

variable "cluster_name" {
  description = "(Required) Middle part of the name of the cluster. Name will be scs-aws-`CLUSTERNAME`-`CLUSTERNUMBER`. Must contain only alphanumeric characters and hyphens."
  type = string
  default = "scs-aws-test-002"
}

variable "auth_token" {
  description = "(Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`."
  type = string
  default = "benevatest1234567890"
}

###############################################################################
# SCS_INSPECTOR
###############################################################################

variable "assessment_name" {
  type = string
  description = "Name of the Inspector Scan"
  default = "test"
}

variable "config_number" {
  type        = string
  description = "Number for the inspector assessment"
  default = "002"
}

###############################################################################
# SCS_PROMETHEUS
###############################################################################

variable "promxy_authorized_cidr" {
  description = "CIDR authorized to connect to prometheus proxy"
  default     = []
}

###############################################################################
# SCS_SNS_TOPIC
###############################################################################

variable "topic_name" {
  description = "The topic name for the alert"
  type        = string
  default     = "test"
}

variable "principal_service" {
  description = "The service name who can call the publish for this topic. Example : es.amazonaws.com"
  type        = string
  default     = "es.amazonaws.com"
}

###############################################################################
# SCS_LAMBDA_ECR_SCAN AND SCS_LAMBDA_PARAMETER
###############################################################################

variable "schedule" {
  type = string
  description = "Schedule used to trigger the lambda"
  default = "rate(1 day)"
}

###############################################################################
# SCS_LAMBDA_INGRESS AND SCS_LAMBDA_PARAMETER
###############################################################################

variable "scs-lambda-name" {
  type        = string
  description = "Name"
  default     = "compliance-test"
}