################################################################################
# VPC
################################################################################
locals {
  instances = { for k, v in var.instances : k => v if var.list_reservations }
}

### IP for Public Gateway
resource "scaleway_vpc_public_gateway_ip" "main" {
  count = length(var.zones)
  tags = concat(
    var.tags,
    var.vpc_tags,
  )
  zone = length(regexall("^[a-z]{2}-", element(var.zones, count.index))) > 0 ? element(var.zones, count.index) : null
}

### IP Reverse for Public Gateway
resource "scaleway_vpc_public_gateway_ip_reverse_dns" "main" {
  count         = length(var.zones) > 0 && var.gateway_reverse_dns ? 1 : 0
  gateway_ip_id = var.gateway_reverse_dns ? scaleway_vpc_public_gateway_ip.main[count.index].id : null
  reverse       = var.reverse_dns_zone
  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
  }
  zone = length(regexall("^[a-z]{2}-", element(var.zones, count.index))) > 0 ? element(var.zones, count.index) : null
}

### The Public Gateway with the Attached IP
resource "scaleway_vpc_public_gateway" "main" {
  count           = length(var.zones)
  name            = lower(coalesce(var.public_gateway_name, var.name))
  type            = var.vpc_public_gateway_type
  ip_id           = scaleway_vpc_public_gateway_ip.main[count.index].id
  bastion_enabled = var.public_gateway_bastion_enabled
  enable_smtp     = var.public_gateway_enable_smtp
  depends_on      = [scaleway_vpc_public_gateway_ip.main]
  tags = concat(
    var.tags,
    var.vpc_tags,
  )
  zone = length(regexall("^[a-z]{2}-", element(var.zones, count.index))) > 0 ? element(var.zones, count.index) : null
  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }
}

### Scaleway Private Network
resource "scaleway_vpc_private_network" "main" {
  count = length(var.zones)
  name  = lower(coalesce(var.private_network_name, var.name))
  tags = concat(
    var.tags,
    var.vpc_tags,
  )
  zone = length(regexall("^[a-z]{2}-", element(var.zones, count.index))) > 0 ? element(var.zones, count.index) : null
}

### DHCP Space of VPC Public Gateway
resource "scaleway_vpc_public_gateway_dhcp" "main" {
  count              = length(var.zones)
  subnet             = var.gateway_dhcp_subnet
  address            = var.gateway_dhcp_address
  pool_low           = var.gateway_dhcp_pool_low
  pool_high          = var.gateway_dhcp_pool_high
  enable_dynamic     = var.gateway_dhcp_enable_dynamic
  push_default_route = var.gateway_dhcp_push_default_route
  push_dns_server    = var.gateway_dhcp_push_dns_server
  dns_servers_override = concat([
    var.gateway_dhcp_address
  ], var.gateway_dhcp_dns_server_servers_override)
  dns_local_name = replace(scaleway_vpc_private_network.main[count.index].name, "_", "-")
  valid_lifetime = var.gateway_dhcp_valid_lifetime
  renew_timer    = var.gateway_dhcp_renew_timer
  rebind_timer   = var.gateway_dhcp_rebind_timer
  dns_search     = var.gateway_dhcp_dns_search
  depends_on     = [scaleway_vpc_private_network.main]
  zone           = length(regexall("^[a-z]{2}-", element(var.zones, count.index))) > 0 ? element(var.zones, count.index) : null
}

### VPC Gateway Network
resource "scaleway_vpc_gateway_network" "main" {
  count              = length(var.zones)
  gateway_id         = scaleway_vpc_public_gateway.main[count.index].id
  private_network_id = scaleway_vpc_private_network.main[count.index].id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.main[count.index].id
  cleanup_dhcp       = var.gateway_network_cleanup_dhcp
  enable_masquerade  = var.gateway_network_enable_masquerade
  depends_on = [
    scaleway_vpc_public_gateway.main, scaleway_vpc_private_network.main,
    scaleway_vpc_public_gateway_dhcp.main
  ]
  zone = length(regexall("^[a-z]{2}-", element(var.zones, count.index))) > 0 ? element(var.zones, count.index) : null
  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }
}

data "scaleway_vpc_public_gateway_dhcp_reservation" "reservations" {
  for_each      = local.instances
  mac_address   = lookup(each.value, "mac_address", null)
  wait_for_dhcp = var.wait_reservations
}
