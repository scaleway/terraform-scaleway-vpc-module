# Scaleway VPC Terraform module

Terraform module that can be used to deploy VPC resources on Scaleway. Common deployment examples can be found in [examples/](./examples).

## Usage

The example below provision a basic VPC with a Public Gateway and a Load Balancer with some instances behind it.

``` hcl
module "vpc" {
  # to modify
  source  = "scaleway/vpc"
  version = ">= 1.0.0"

  private_network_name = "my_vpc"
  zone                 = "fr-par-1"
}
```

## Requirements

| Name                                                                      | Version   |
| ------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13   |
| <a name="requirement_terraform"></a> [scaleway](#requirement\_scaleway)   | >= 2.10.0 |

## Providers

| Name                                                             | Version   |
| ---------------------------------------------------------------- | --------- |
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | >= 2.10.0 |

## Resources

| Name                                                                                                                                                                 | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [scaleway_vpc_public_gateway_ip](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/vpc_public_gateway_ip)                              | resource |
| [scaleway_vpc_public_gateway](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/vpc_public_gateway)                                    | resource |
| [scaleway_vpc_private_network](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/vpc_private_network)                                  | resource |
| [scaleway_vpc_public_gateway_dhcp](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/vpc_public_gateway_dhcp)                          | resource |
| [scaleway_vpc_gateway_network](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/vpc_gateway_network)                                  | resource |
| [scaleway_instance_server](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_server)                                          | resource |
| [scaleway_vpc_public_gateway_dhcp_reservation](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/vpc_public_gateway_dhcp_reservation)) | resource |
| [scaleway_lb_backend](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_backend)                                                    | resource |
| [scaleway_lb_ip](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_ip)                                                              | resource |
| [scaleway_lb](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb)                                                                    | resource |
| [scaleway_lb_certificate](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_certificate)                                            | resource |
## Inputs

| Name                                     | Description                                                                                                                                                                          | Type           | Default        | Required |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------| -------------- | -------- |
| reverse_dns_zone                         | Reverse domain name for the IP address                                                                                                                                               | `bool`         | false          | no       |
| gateway_reverse_dns                      | Create (reserve) a new flexible IP address that can be used for a Public Gateway in a specified Scaleway Project                                                                     | `bool`         | false          | no       |
| private_network_name                     | Name to be used on private network resource as identifier                                                                                                                            | `string`       | ""             | **yes**  |
| public_gateway_name                      | Name to be used on gateway resource as identifier                                                                                                                                    | `string`       | ""             | yes      |
| vpc_public_gateway_type                  | Type to be used on gateway resource as default                                                                                                                                       | `string`       | VPC-GW-S       | no       |
| public_gateway_bastion_enabled           | Defines whether SSH bastion is enabled on the gateway                                                                                                                                | `bool`         | true           | no       |
| name                                     | Name to be used on all the resources as identifier                                                                                                                                   | `string`       | ""             | no       |
| tags                                     | A list of tags to add to all resources                                                                                                                                               | `list(string)` | []             | no       |
| vpc_tags                                 | Additional tags for the VPC                                                                                                                                                          | `list(string)` | []             | no       |
| azs                                      | Zones in which resources should be created                                                                                                                                           | `list(string)` | null           | **yes**  |
| timeouts                                 | Define maximum timeout for creating, updating, and deleting VPC resources                                                                                                            | `map(string)`  | {}             | no       |
| gateway_reserve_ip                       | Reserve a flexible IP for the gateway.                                                                                                                                               | `bool`         | false          | no       |
| public_gateway_dns_reverse               | Defines a reverse domain name for the IP address                                                                                                                                     | `string`       | null           | no       |
| gateway_network_cleanup_dhcp             | Defines whether to clean up attached DHCP configurations (if any, and if not attached to another Gateway Network)                                                                    | `bool`         | true           | no       |
| gateway_network_enable_masquerade        | Defines whether the gateway should masquerade traffic for the attached Private Network (i.e. whether to enable dynamic NAT)                                                          | `bool`         | true           | no       |
| gateway_dhcp_subnet                      | Subnet for the DHCP server                                                                                                                                                           | `string`       | 192.168.0.0/24 | no       |
| gateway_dhcp_address                     | IP address of the DHCP server. This will be the gateway's address in the Private Network. Defaults to the first address of the subnet. (IP address)                                  | `string`       | 192.168.0.1    | no       |
| gateway_dhcp_pool_low                    | Low IP (inclusive) of the dynamic address pool. Must be in the config's subnet. Defaults to the second address of the subnet. (IP address)                                           | `string`       | 192.168.0.2    | no       |
| gateway_dhcp_pool_high                   | High IP (inclusive) of the dynamic address pool. Must be in the config's subnet. Defaults to the last address of the subnet. (IP address)                                            | `string`       | 192.168.0.254  | no       |
| gateway_dhcp_enable_dynamic              | Defines whether to enable dynamic pooling of IPs. When false, only pre-existing DHCP reservations will be handed out. Defaults to true                                               | `bool`         | true           | no       |
| gateway_dhcp_push_default_route          | Defines whether the gateway should push a default route to DHCP clients or only hand out IPs. Defaults to true                                                                       | `bool`         | true           | no       |
| gateway_dhcp_push_dns_server             | Defines whether the gateway should push custom DNS servers to clients. This allows for Instance hostname -> IP resolution. Defaults to true.                                         | `bool`         | true           | no       |
| gateway_dhcp_dns_server_servers_override | A list of additional Array of DNS server IP addresses used to override the DNS server list pushed to DHCP clients, instead of the gateway itself. Default the `gateway_dhcp_address` | `list(string)` | []             | no       |
| gateway_dhcp_valid_lifetime              | How long DHCP entries will be valid for (in seconds)                                                                                                                                 | `string`       | 3600           | no       |
| gateway_dhcp_renew_timer                 | After how long a renew will be attempted. Must be 30s lower than `rebind_timer`. (in seconds)                                                                                        | `string`       | 3000           | no       |
| gateway_dhcp_rebind_timer                | After how long a DHCP client will query for a new lease if previous renews fail. Must be 30s lower than `valid_lifetime`. (in seconds)                                               | `string`       | 3060           | no       |
| gateway_dhcp_dns_search                  | Array of DNS server IP addresses used to override the DNS server list pushed to DHCP clients, instead of the gateway itself                                                          | `list(string)` | []             | no       |
| instances                                | A map of interface and/or instance mac addresses containing their properties                                                                                                         | `any`          | {}             | no       |
| wait_reservations                        | Determines whether wait reservations are available                                                                                                                                   | `bool`         | true           | no       |

## Outputs

| Name                      | Description                                                                   |
| ------------------------- | ----------------------------------------------------------------------------- |
| public_gateway_ip_address | Address of the public gateway IP.                                             |
| public_gateway_ip_id      | ID of gateway IP.                                                             |
| public_gateway_id         | ID of public gateway.                                                         |
| private_network_id        | ID of private networks.                                                       |
| reservations              | Array containing the full resource object and attributes for all reservations |
