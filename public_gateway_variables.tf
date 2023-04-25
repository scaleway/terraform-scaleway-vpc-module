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
