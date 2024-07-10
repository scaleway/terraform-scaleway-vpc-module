output "default_public_gateway_ip_addresses" {
  description = "Addresses of the public gateway IP."
  value       = module.vpc.public_gateway_ip_address
}

output "default_public_gateway_ip_ids" {
  description = "IDs of gateway IP."
  value       = module.vpc.public_gateway_ip_id
}

output "default_public_gateway_ids" {
  description = "IDs of public gateways."
  value       = module.vpc.public_gateway_id
}

output "default_private_network_ids" {
  description = "IDs of private networks."
  value       = module.vpc.private_network_id
}
