<!-- BEGIN_TF_DOCS -->

![alt text](diagram.png)

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.12.2 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | 2.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.41.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.1.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.41.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | azure/avm-res-network-bastionhost/azurerm | 0.8.1 |
| <a name="module_kv"></a> [kv](#module\_kv) | azure/avm-res-keyvault-vault/azurerm | 0.10.1 |
| <a name="module_nsg"></a> [nsg](#module\_nsg) | azure/avm-res-network-networksecuritygroup/azurerm | 0.5.0 |
| <a name="module_rg"></a> [rg](#module\_rg) | azure/avm-res-resources-resourcegroup/azurerm | 0.2.1 |
| <a name="module_vm"></a> [vm](#module\_vm) | azure/avm-res-compute-virtualmachine/azurerm | 0.19.3 |
| <a name="module_vm_sku"></a> [vm\_sku](#module\_vm\_sku) | azure/avm-utl-sku-finder/azapi | 0.3.0 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | azure/avm-res-network-virtualnetwork/azurerm | 0.10.0 |

#### Resources

| Name | Type |
|------|------|
| [null_resource.register_encryption_at_host_feature](https://registry.terraform.io/providers/hashicorp/null/3.2.4/docs/resources/resource) | resource |
| [null_resource.register_multiple_peering_feature](https://registry.terraform.io/providers/hashicorp/null/3.2.4/docs/resources/resource) | resource |
| [random_string.random_suffix](https://registry.terraform.io/providers/hashicorp/random/3.7.2/docs/resources/string) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/4.1.0/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.41.0/docs/data-sources/client_config) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address spaces for both virtual networks | `list(any)` | <pre>[<br/>  "10.0.0.0/16",<br/>  "10.1.0.0/16"<br/>]</pre> | no |
| <a name="input_bastion_name"></a> [bastion\_name](#input\_bastion\_name) | Bastion Host names | `list(string)` | <pre>[<br/>  "bas-vnet-left",<br/>  "bas-vnet-right"<br/>]</pre> | no |
| <a name="input_default_location"></a> [default\_location](#input\_default\_location) | Default Azure location for resources | `string` | `"Australia East"` | no |
| <a name="input_enable_peering"></a> [enable\_peering](#input\_enable\_peering) | Enable or disable VNET peering block in locals | `bool` | `true` | no |
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | Network Security Group names | `list(any)` | <pre>[<br/>  "nsg-left",<br/>  "nsg-right"<br/>]</pre> | no |
| <a name="input_private_key_name"></a> [private\_key\_name](#input\_private\_key\_name) | Name of the private key secret in Key Vault for VM SSH access | `string` | `"azureuser-ssh-private-key"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource Group Name | `string` | `"rg-snet-peering"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | List of subnets for both virtual networks | `list(string)` | <pre>[<br/>  "snet1-left",<br/>  "snet2-left",<br/>  "snet3-left",<br/>  "snet1-right",<br/>  "snet2-right",<br/>  "snet3-right"<br/>]</pre> | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources | `map(string)` | <pre>{<br/>  "deployment": "terraform",<br/>  "environment": "lab",<br/>  "project": "subnet peering"<br/>}</pre> | no |
| <a name="input_vm_admin_user"></a> [vm\_admin\_user](#input\_vm\_admin\_user) | Admin username for the VMs | `string` | `"azureuser"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Names of the virtual networks | `list(any)` | <pre>[<br/>  "vnet-left",<br/>  "vnet-right"<br/>]</pre> | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_connection_guide"></a> [bastion\_connection\_guide](#output\_bastion\_connection\_guide) | Step-by-step guide for connecting to VMs via Azure Bastion using Key Vault SSH keys |
<!-- END_TF_DOCS -->
