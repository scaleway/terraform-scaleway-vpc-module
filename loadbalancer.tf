################################################################################
# LOAD BALANCER
################################################################################

resource "scaleway_lb_backend" "backend" {
  name             = lower(coalesce(var.load_balancer_frontend_backend, var.name))
  lb_id            = scaleway_lb.main.id
  forward_protocol = var.load_balancer_backend_forward_protocol
  forward_port     = var.load_balancer_backend_forward_port
  server_ips       = scaleway_vpc_public_gateway_dhcp_reservation.app.*.ip_address

  health_check_tcp {}
}

resource "scaleway_lb_frontend" "frontend" {
  name            = lower(coalesce(var.load_balancer_frontend_name, var.name))
  lb_id           = scaleway_lb.main.id
  backend_id      = scaleway_lb_backend.backend.id
  inbound_port    = var.load_balancer_frontend_inbound_port
  certificate_ids = [scaleway_lb_certificate.cert.id]
}

### IP for LB IP
resource "scaleway_lb_ip" "main" {
}

resource "scaleway_lb" "main" {
  ip_id = scaleway_lb_ip.main.id
  name  = lower(coalesce(var.load_balancer_name, var.name))
  type  = var.load_balancer_type

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