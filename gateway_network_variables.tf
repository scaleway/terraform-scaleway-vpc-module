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
