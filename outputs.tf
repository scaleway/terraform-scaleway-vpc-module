output "public_gateway_ip_address" {
  description = "Address of the public gateway IP."
  value       = try(scaleway_vpc_public_gateway_ip.main[*].address, null)
}

output "public_gateway_ip_id" {
  description = "ID of gateway IP."
  value       = try(scaleway_vpc_public_gateway_ip.main[*].id, null)
}

output "public_gateway_id" {
  description = "ID of public gateways."
  value       = try(scaleway_vpc_public_gateway.main[*].id, null)
}

output "private_network_id" {
  description = "ID of private networks."
  value       = scaleway_vpc_private_network.main[*].id
}

output "dhcp_reservations" {
  description = "ID of VPC Gateway DHCP reservations."
  value       = data.scaleway_vpc_public_gateway_dhcp_reservation.reservations[*]
}
