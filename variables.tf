variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000" # Replace with your actual Subscription ID
}

variable "rg_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-snet-peering"
}

variable "default_location" {
  description = "Default Azure location for resources"
  type        = string
  default     = "Australia East"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    project     = "subnet peering"
    environment = "demo"
    deployment  = "terraform"
  }
}

variable "nsg_name" {
  description = "Network Security Group names"
  type        = list(any)
  default = [
    "nsg-left",
    "nsg-right"
  ]
}

variable "vnet_name" {
  description = "Names of the virtual networks"
  type        = list(any)
  default = [
    "vnet-left",
    "vnet-right"
  ]
}

variable "address_space" {
  description = "Address spaces for both virtual networks"
  type        = list(any)
  default = [
    "10.0.0.0/16",
    "10.1.0.0/16"
  ]
}

variable "subnet_name" {
  description = "List of subnets for both virtual networks"
  type        = list(string)
  default = [
    "snet1-left",
    "snet2-left",
    "snet3-left",
    "snet1-right",
    "snet2-right",
    "snet3-right"
  ]
}

variable "enable_peering" {
  description = "Enable or disable VNET peering block in locals"
  type        = bool
  default     = true # Set FALSE to disable it or TRUE to enable it
}

variable "bastion_name" {
  description = "Bastion Host names"
  type        = list(string)
  default = [
    "bas-vnet-left",
    "bas-vnet-right"
  ]
}

variable "private_key_name" {
  description = "Name of the private key secret in Key Vault for VM SSH access"
  type        = string
  default     = "azureuser-ssh-private-key"
}

variable "vm_admin_user" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}
