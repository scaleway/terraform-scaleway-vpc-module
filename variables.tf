################################################################################
# General
################################################################################
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A list of tags to add to all resources"
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = list(string)
  default     = []
}

variable "zone" {
  description = "Zone in which resources should be created"
  type        = string
  default     = null
}

variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC resources"
  type        = map(string)
  default     = {}
}

