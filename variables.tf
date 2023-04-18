variable "scale" {
  description = "Controls if number of Instances should be created"
  default     = 3
}

################################################################################
# VPC
################################################################################

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "private_network_name" {
  description = "Name to be used on private network resource as identifier"
  type        = string
  default     = ""
}

variable "load_balancer_name" {
  description = "Name to be used on load balancer resource as identifier"
  type        = string
  default     = ""
}

variable "public_gateway_name" {
  description = "Name to be used on gateway resource as identifier"
  type        = string
  default     = ""
}

variable "vpc_public_gateway_type" {
  description = "Type to be used on gateway resource as default"
  type        = string
  default     = "VPC-GW-S"
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_gateway_ip_tags" {
  description = "Additional tags for the gateway IP"
  type        = list(string)
  default     = []
}

variable "vpc_gateway_tags" {
  description = "Additional tags for the gateway"
  type        = list(string)
  default     = []
}

variable "vpc_private_network_tags" {
  description = "Additional tags for the VPC Private Network"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A list of tags to add to all resources"
  type        = list(string)
  default     = []
}

################################################################################
# Public Subnets
################################################################################

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_ip_prefixes" {
  description = "Assigns IP public subnet id based on the Scaleway provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}