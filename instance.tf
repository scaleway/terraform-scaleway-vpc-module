################################################################################
# INSTANCE
################################################################################
resource "scaleway_instance_server" "srv" {
  count = var.scale
  name  = format("srv-%d", count.index)
  image = var.instance_image
  type  = var.instance_type

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