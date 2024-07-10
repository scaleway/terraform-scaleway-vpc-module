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

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC resources"
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

################################################################################
# PUBLIC GATEWAY
################################################################################
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

variable "public_gateway_bastion_enabled" {
  type        = bool
  default     = true
  description = "Defines whether SSH bastion is enabled on the gateway"
}

variable "public_gateway_enable_smtp" {
  type        = bool
  default     = false
  description = "Defines whether SMTP is allowed on the gateway"
}

################################################################################
# GATEWAY NETWORK
################################################################################
variable "gateway_network_cleanup_dhcp" {
  type        = bool
  default     = true
  description = "Defines whether to clean up attached DHCP configurations (if any, and if not attached to another Gateway Network)"
}

variable "gateway_network_enable_masquerade" {
  type        = bool
  default     = true
  description = "Defines whether the gateway should masquerade traffic for the attached Private Network (i.e. whether to enable dynamic NAT)"
}

################################################################################
# GATEWAY IP REVERSE DNS
################################################################################
variable "reverse_dns_zone" {
  type        = string
  default     = false
  description = "Reverse domain name for the IP address"
}

variable "gateway_reverse_dns" {
  type        = bool
  default     = false
  description = "Create (reserve) a new flexible IP address that can be used for a Public Gateway in a specified Scaleway Project"
}

################################################################################
# PRIVATE NETWORK
################################################################################
variable "private_network_name" {
  type        = string
  default     = ""
  description = "Name to be used on private network resource as identifier"
}

variable "private_network_ipv4_subnet" {
  type        = string
  default     = "192.168.0.0/24"
  description = "IPv4 subnet to be used on private network resource"
}
