/*
#
# Variables
#
*/
variable "topic_name" {
  description = "The topic name for the alert"
  type        = string
}

variable "principal_service" {
  description = "The service name who can call the publish for this topic. Example : es.amazonaws.com"
  type        = string

}
