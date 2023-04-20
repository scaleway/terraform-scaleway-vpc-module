################################################################################
# VPC
################################################################################

### IP for Public Gateway
resource "scaleway_vpc_public_gateway_ip" "main" {
#  count   = var.gateway_enabled ? 1 : 0
  tags    = concat(
    var.tags,
    var.vpc_tags,
  )
  zone = var.zone
}

#resource "scaleway_vpc_public_gateway_ip_reverse_dns" "main" {
#  count         = var.gateway_enabled && var.gateway_reverse_dns ? 1 : 0
#  gateway_ip_id = scaleway_vpc_public_gateway_ip.main.id
#  reverse       = var.reverse_dns_zone
#}

### The Public Gateway with the Attached IP
resource "scaleway_vpc_public_gateway" "main" {
#  count           = var.gateway_enabled ? 1 : 0
  name            = lower(coalesce(var.public_gateway_name, var.name))
  type            = var.vpc_public_gateway_type
  ip_id           = scaleway_vpc_public_gateway_ip.main.id
  bastion_enabled = var.public_gateway_bastion_enabled
  depends_on      = [scaleway_vpc_public_gateway_ip.main]
  tags            = concat(
    var.tags,
    var.vpc_tags,
  )
  zone = var.zone
}

### Scaleway Private Network
resource "scaleway_vpc_private_network" "main" {
  name = lower(coalesce(var.private_network_name, var.name))
  tags = concat(
    var.tags,
    var.vpc_tags,
  )
  zone = var.zone
}

### DHCP Space of VPC
resource "scaleway_vpc_public_gateway_dhcp" "main" {
#  count                = var.gateway_enabled ? 1 : 0
  subnet               = var.gateway_dhcp_subnet
  address              = var.gateway_dhcp_address
  pool_low             = var.gateway_dhcp_pool_low
  pool_high            = var.gateway_dhcp_pool_high
  enable_dynamic       = var.gateway_dhcp_enable_dynamic
  push_default_route   = var.gateway_dhcp_push_default_route
  push_dns_server      = var.gateway_dhcp_push_dns_server
  dns_servers_override = concat([var.gateway_dhcp_address], var.gateway_dhcp_dns_server_servers_override)
  dns_local_name       = scaleway_vpc_private_network.main.name
  valid_lifetime       = var.gateway_dhcp_valid_lifetime
  renew_timer          = var.gateway_dhcp_renew_timer
  rebind_timer         = var.gateway_dhcp_rebind_timer
  dns_search           = var.gateway_dhcp_dns_search
  depends_on           = [scaleway_vpc_private_network.main]
}

### VPC Gateway Network
resource "scaleway_vpc_gateway_network" "main" {
#  count              = var.gateway_enabled ? 1 : 0
  gateway_id         = scaleway_vpc_public_gateway.main.id
  private_network_id = scaleway_vpc_private_network.main.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.main.id
  cleanup_dhcp       = var.gateway_network_cleanup_dhcp
  enable_masquerade  = var.gateway_network_enable_masquerade
  depends_on         = [
    scaleway_vpc_public_gateway.main, scaleway_vpc_private_network.main, scaleway_vpc_public_gateway_dhcp.main
  ]
  zone = var.zone
}