output "public_gateway_ip_address" {
  description = "Address of the public gateway IP."
  value       = try(scaleway_vpc_public_gateway_ip.main[0].address, null)
}

output "public_gateway_ip_id" {
  description = "ID of gateway IP."
  value       = try(scaleway_vpc_public_gateway_ip.main[0].id, null)
}

output "public_gateway_id" {
  description = "ID of public gateways."
  value       = try(scaleway_vpc_public_gateway.main[0].id, null)
}

output "private_network_id" {
  description = "ID of private networks."
  value       = scaleway_vpc_private_network.main.id
}

output "reservations" {
  description = "Array containing the full resource object and attributes for all reservations"
  value       = try(data.scaleway_vpc_public_gateway_dhcp_reservation.reservations, null)
}