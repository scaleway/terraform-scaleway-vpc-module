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
