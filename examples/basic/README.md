# Basic VPC

Configuration in this directory creates a set of VPC resources which may be sufficient for development environment.

For demonstration purposes, a public subnet, private subnet, and DHCP server are created per availability zone.

In typical scenarios, specifying names or custom CIDR configuration is sufficient, without the need for this setup.

[Read more about Scaleway regions, zones](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/guides/regions_and_zones).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

| Name                                                                      | Version |
|---------------------------------------------------------------------------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0  |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway)    | >= 2.17 |

## Providers

| Name                                                             | Version |
|------------------------------------------------------------------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | >= 2.17 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../ | n/a |

## Inputs

No inputs.

## Outputs

| Name                                | Description                                                                  |
|-------------------------------------|------------------------------------------------------------------------------|
| default_public_gateway_ip_addresses | List of Address of the public gateway IP.                                    |
| default_public_gateway_ip_id        | List of IDs of gateway IP.                                                   |
| default_public_gateway_id           | List of IDs of public gateway.                                               |
| default_private_network_id          | List of IDs of private networks.                                             |
| dhcp_reservations                   | List containing the full resource object and attributes for all reservations |
