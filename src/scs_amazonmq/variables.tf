
###############################################################################
# AMAZONMQ RESOURCE
###############################################################################

variable "broker_name" {
  description = "(Required) Middle part of the name of the broker. Name will be scs-aws-`BROKERRNAME`-`BROKERNUMBER`. Must contain only alphanumeric characters and hyphens."
  type = string
}

variable "broker_number" {
  description = "(Optional) Last part of the name of the broker. Name will be scs-aws-`BROKERRNAME`-`BROKERNUMBER`. Must contain only alphanumeric characters and hyphens. Defaults to `001`."
  default = "001"
}

variable "deployment_mode" {
  description = "(Optional) The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ. Defaults to ACTIVE_STANDBY_MULTI_AZ."
  type = string
  default = "ACTIVE_STANDBY_MULTI_AZ"
}

variable "engine_type" {
  description = "(Optional) The type of broker engine. Currently, `aws_mq_broker` supports only ActiveMQ. Defaults to `ActiveMQ`."
  type = string
  default = "ActiveMQ"
}

variable "engine_version" {
  description = "(Optional) The version of the broker engine. Defaults to 5.15.0."
  type = string
  default = "5.15.0"
}

variable "instance_type" {
  description = "(Optional) The broker's instance type. Defaults to mq.m5.large."
  type = string
  default = "mq.m5.large"
}

variable "admin_username" {
  description = "(Required) Username of the admin user."
  type = string
}

variable "admin_password" {
  description = "(Required) Password of the admin user. It must be 12 to 250 characters long, at least 4 unique characters, and must not contain commas."
  type = string
}

variable "application_username" {
  description = "(Required) Username of the application user."
  type = string
}

variable "application_password" {
  description = "(Required) Password of the application user. It must be 12 to 250 characters long, at least 4 unique characters, and must not contain commas."
  type = string
}

###############################################################################
# NETWORK / NETWORK SECURITY
###############################################################################

variable "vpc_id" {
  description = "(Required) VPC ID."
  type = string
}

variable "subnet_ids" {
  description = "(Required) List of subnet IDs in which to launch the broker. Only 1 if deployment mode is SINGLE_INSTANCE, at least 2 otherwise."
  type = list(string)
}

variable "allowed_security_groups" {
  description = "(Optional) List of security-groups from which inbound connections are allowed. Defaults to `[]`."
  default = []
  type = list(string)
}

variable "allowed_cidrs" {
  description = "(Optional) List of CIDR blocks from which inbound connections are allowed. Defaults to `[]`."
  default = []
  type = list(string)
}

variable "allowed_protocols" {
  description = "(Required) List of protocols for which inbound connections are allowed. Supported: AMQP (tcp/5671), CONSOLE (tcp/8162), MQTT (tcp/8883), STOMP (tcp/61614), OpenWire (tcp/61617) and WebSocket (tcp/61619)."
  type = list(string)
}

###############################################################################
# TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "(Required) A map of tags to assign to the resource."
}

###############################################################################
# INTERNAL
###############################################################################

variable "protocols" {
  type = map
  default = {
    "AMQP"      = "5671"
    "CONSOLE"   = "8162"
    "MQTT"      = "8883"
    "STOMP"     = "61614"
    "OpenWire"  = "61617"
    "WebSocket" = "61619"
  }
}
