################################################################################
# VPC
################################################################################

### IP for Public Gateway
resource "scaleway_vpc_public_gateway_ip" "main" {
  tags = concat(
    var.vpc_gateway_ip_tags,
    var.vpc_tags,
    var.tags
  )
}

### The Public Gateway with the Attached IP
resource "scaleway_vpc_public_gateway" "main" {
  name            = lower(coalesce(var.public_gateway_name, var.name))
  type            = var.vpc_public_gateway_type
  ip_id           = scaleway_vpc_public_gateway_ip.main.id
  bastion_enabled = true
  depends_on      = [scaleway_vpc_public_gateway_ip.main]
  tags = concat(
    var.vpc_gateway_tags,
    var.vpc_tags,
    var.tags
  )
}

### Scaleway Private Network
resource "scaleway_vpc_private_network" "main" {
  name = lower(coalesce(var.private_network_name, var.name))
  tags = concat(
    var.tags,
    var.vpc_tags,
    var.vpc_private_network_tags
  )
}

### DHCP Space of VPC
resource "scaleway_vpc_public_gateway_dhcp" "main" {
  subnet               = "192.168.1.0/24"
  address              = "192.168.0.1"
  pool_low             = "192.168.0.2"
  pool_high            = "192.168.0.50"
  enable_dynamic       = true
  push_default_route   = true
  push_dns_server      = true
  dns_servers_override = ["192.168.0.1"]
  dns_local_name       = scaleway_vpc_private_network.main.name
  depends_on           = [scaleway_vpc_private_network.main]
}

### VPC Gateway Network
resource "scaleway_vpc_gateway_network" "main" {
  gateway_id         = scaleway_vpc_public_gateway.main.id
  private_network_id = scaleway_vpc_private_network.main.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.main.id
  cleanup_dhcp       = true
  enable_masquerade  = true
  depends_on         = [scaleway_vpc_public_gateway.main, scaleway_vpc_private_network.main, scaleway_vpc_public_gateway_dhcp.main, scaleway_instance_server.srv]

}

resource "scaleway_vpc_public_gateway_dhcp_reservation" "app" {
  count              = var.scale
  gateway_network_id = scaleway_vpc_gateway_network.main.id
  mac_address        = scaleway_instance_server.srv[count.index].private_network.0.mac_address
  ip_address         = format("192.168.0.%d", (60 + count.index))
  depends_on         = [scaleway_instance_server.srv]
}