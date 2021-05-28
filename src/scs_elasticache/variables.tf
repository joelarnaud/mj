###############################################################################
# ELASTICACHE RESSOURCE
###############################################################################

variable "cluster_name" {
  description = "(Required) Middle part of the name of the cluster. Name will be scs-aws-`CLUSTERNAME`-`CLUSTERNUMBER`. Must contain only alphanumeric characters and hyphens."
  type = string
}

variable "cluster_number" {
  description = "(Optional) Last part of the name of the cluster. Name will be scs-aws-`CLUSTERNAME`-`CLUSTERNUMBER`. Must contain only alphanumeric characters and hyphens. Defaults to `001`."
  default = "001"
}

variable "engine" {
  description = "(Optional) Engine to be used for the cluster. Supported: `redis` and `memcached`. Defaults to `redis`."
  type = string
  default = "redis"
}

variable "engine_version" {
  description = "(Optional) Version number of the engine to be used. Defaults to `5.0.6`."
  type = string
  default = "5.0.6"
}

variable "number_cache_clusters" {
description = "(Optional) Number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Defaults to 2."
  default = "2"
  type = string
}

variable "automatic_failover_enabled" {
  description = "(Optional) Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. Defaults to true."
  default = "true"
  type = string
}

variable "node_type" {
  description = "(Optional) Compute and memory capacity of the nodes. Defaults to `cache.r5.large`."
  default = "cache.r5.large"
  type = string
}

variable "port" {
  description = "(Optional) Port number on which nodes will accept connections. Defaults to 6379."
  default = "6379"
  type = string
}

variable "at_rest_encryption_enabled" {
  description = "(Optional) Whether to enable encryption at rest. Defaults to true."
  default = "true"
  type = string
}

variable "transit_encryption_enabled" {
  description = "(Optional) Whether to enable encryption in transit. Defaults to true."
  default = "true"
  type = string
}

variable "auth_token" {
  description = "(Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`."
  default = null
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
  description = "(Required) List of subnet IDs in which to launch the cluster."
  type = list(string)
}

variable "allowed_security_groups" {
  description = "(Optional) List of security-groups from which inbound/outbound connections are allowed. Defaults to `[]`."
  default = []
  type = list(string)
}

variable "allowed_cidrs" {
  description = "(Optional) List of CIDR blocks from which inbound/outbound connections are allowed. Defaults to `[]`."
  default = []
  type = list(string)
}

###############################################################################
# TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "(Required) A map of tags to assign to the resource."
}
