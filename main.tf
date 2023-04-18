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
  depends_on         = [scaleway_vpc_public_gateway.main, scaleway_vpc_private_network.main, scaleway_vpc_public_gateway_dhcp.main, scaleway_instance_server.main]

}

### Scaleway Instance
resource "scaleway_instance_server" "main" {
  name        = "Scaleway Terraform Provider"
  type        = "DEV1-S"
  image       = "debian_bullseye"
  enable_ipv6 = false

  private_network {
    pn_id = scaleway_vpc_private_network.main.id
  }
}

resource "scaleway_vpc_public_gateway_dhcp_reservation" "app" {
  count              = var.scale
  gateway_network_id = scaleway_vpc_gateway_network.main.id
  mac_address        = scaleway_instance_server.srv[count.index].private_network.0.mac_address
  ip_address         = format("192.168.0.%d", (60 + count.index))
  depends_on         = [scaleway_instance_server.srv]
}

################################################################################
# LOAD BALANCER
################################################################################

resource "scaleway_lb_backend" "backend" {
  name             = "backend-app"
  lb_id            = scaleway_lb.main.id
  forward_protocol = "tcp"
  forward_port     = 80
  server_ips       = scaleway_vpc_public_gateway_dhcp_reservation.app.*.ip_address

  health_check_tcp {}
}

### IP for LB IP
resource "scaleway_lb_ip" "main" {
}

resource "scaleway_lb" "main" {
  ip_id = scaleway_lb_ip.main.id
  name  = lower(coalesce(var.load_balancer_name, var.name))
  type  = "LB-S"

  private_network {
    private_network_id = scaleway_vpc_private_network.main.id
    dhcp_config        = true
  }

  depends_on = [scaleway_vpc_public_gateway.main]
}

resource "scaleway_lb_certificate" "cert" {
  lb_id = scaleway_lb.main.id
  name  = lower(coalesce(var.load_balancer_name, var.name))

  letsencrypt {
    common_name = format("app.%s.lb.%s.scw.cloud", replace(scaleway_lb_ip.main.ip_address, ".", "-"), scaleway_lb.main.region)
  }
}

resource "scaleway_lb_frontend" "frontend" {
  name            = "frontend-https"
  lb_id           = scaleway_lb.main.id
  backend_id      = scaleway_lb_backend.backend.id
  inbound_port    = 443
  certificate_ids = [scaleway_lb_certificate.cert.id]
}

################################################################################
# INSTANCE
################################################################################


resource "scaleway_instance_server" "srv" {
  count = var.scale
  name  = format("srv-%d", count.index)
  image = "ubuntu_jammy"
  type  = "DEV1-S"

  private_network {
    pn_id = scaleway_vpc_private_network.main.id
  }

  user_data = {
    cloud-init = <<-EOT
    #cloud-config
    runcmd:
      - apt-get update
      - apt-get install nginx -y
      - systemctl enable --now nginx
      - hostnamectl hostname ${format("srv-%d.%s", count.index, scaleway_vpc_private_network.main.name)}
      - echo "Hello i'm $(hostname)!" > /var/www/html/index.nginx-debian.html
      - reboot # Make sure static DHCP reservation catch up
    EOT
  }

}