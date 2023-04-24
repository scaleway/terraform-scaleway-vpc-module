################################################################################
# GATEWAY IP REVERSE DNS
################################################################################

variable "reverse_dns_zone" {
  type        = bool
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
# DHCP
################################################################################
variable "gateway_dhcp_subnet" {
  type        = string
  default     = "192.168.0.0/24"
  description = "Subnet for the DHCP server."
}

variable "gateway_dhcp_address" {
  type        = string
  default     = "192.168.0.1"
  description = "IP address of the DHCP server. This will be the gateway's address in the Private Network. Defaults to the first address of the subnet. (IP address)"
}

variable "gateway_dhcp_pool_low" {
  type        = string
  default     = "192.168.0.2"
  description = "Low IP (inclusive) of the dynamic address pool. Must be in the config's subnet. Defaults to the second address of the subnet. (IP address)"
}

variable "gateway_dhcp_pool_high" {
  type        = string
  default     = "192.168.0.254"
  description = "High IP (inclusive) of the dynamic address pool. Must be in the config's subnet. Defaults to the last address of the subnet. (IP address)"
}

variable "gateway_dhcp_enable_dynamic" {
  type        = bool
  default     = true
  description = "Defines whether to enable dynamic pooling of IPs. When false, only pre-existing DHCP reservations will be handed out. Defaults to true"
}

variable "gateway_dhcp_push_default_route" {
  type        = bool
  default     = true
  description = "Defines whether the gateway should push a default route to DHCP clients or only hand out IPs. Defaults to true"
}

variable "gateway_dhcp_push_dns_server" {
  type        = bool
  default     = true
  description = "Defines whether the gateway should push custom DNS servers to clients. This allows for Instance hostname -> IP resolution. Defaults to true."
}

variable "gateway_dhcp_dns_server_servers_override" {
  type        = list(string)
  default     = []
  description = "A list of additional Array of DNS server IP addresses used to override the DNS server list pushed to DHCP clients, instead of the gateway itself. Default the `gateway_dhcp_address` "
}

variable "gateway_dhcp_valid_lifetime" {
  default     = 3600
  type        = number
  description = "How long DHCP entries will be valid for. Defaults to 1h (3600s). (in seconds"
}

variable "gateway_dhcp_renew_timer" {
  default     = 3000
  type        = number
  description = "After how long a renew will be attempted. Must be 30s lower than `rebind_timer`. Defaults to 50m (3000s). (in seconds)"
}

variable "gateway_dhcp_rebind_timer" {
  default     = 3060
  type        = number
  description = "After how long a DHCP client will query for a new lease if previous renews fail. Must be 30s lower than `valid_lifetime`. Defaults to 51m (3060s). (in seconds)"
}

variable "gateway_dhcp_dns_search" {
  type        = list(string)
  default     = null
  description = "Array of DNS server IP addresses used to override the DNS server list pushed to DHCP clients, instead of the gateway itself"
}

variable "instances" {
  description = "A map of interface and/or instance mac addresses containing their properties"
  type        = any
  default     = {}
}

variable "wait_reservations" {
  description = "Determines whether wait reservations are available"
  type        = bool
  default     = true
}
