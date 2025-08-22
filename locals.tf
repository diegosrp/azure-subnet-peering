locals {
  #-------------------------------------------------------------------------------------------------------------------------------
  # VNETs - This section defines the virtual networks and their subnets, including peering configurations
  #-------------------------------------------------------------------------------------------------------------------------------
  vnet_resource_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name[0]}"

  vnet = {
    vnet1 = {
      name          = var.vnet_name[0]
      address_space = [var.address_space[0]]
      subnets = {
        subnet1 = {
          name             = var.subnet_name[0]
          address_prefixes = [cidrsubnet(var.address_space[0], 8, 1)]
          network_security_group = {
            id = module.nsg["nsg-left"].resource_id
          }
        }
        subnet2 = {
          name             = var.subnet_name[1]
          address_prefixes = [cidrsubnet(var.address_space[0], 8, 3)]
          network_security_group = {
            id = module.nsg["nsg-left"].resource_id
          }
        }
        subnet3 = {
          name             = var.subnet_name[2]
          address_prefixes = [cidrsubnet(var.address_space[0], 8, 5)]
          network_security_group = {
            id = module.nsg["nsg-left"].resource_id
          }
        }
      }
      peerings = {}
    }

    vnet2 = {
      name          = var.vnet_name[1]
      address_space = [var.address_space[1]]
      subnets = {
        subnet1 = {
          name             = var.subnet_name[3]
          address_prefixes = [cidrsubnet(var.address_space[1], 8, 1)]
          network_security_group = {
            id = module.nsg["nsg-right"].resource_id
          }
        }
        subnet2 = {
          name             = var.subnet_name[4]
          address_prefixes = [cidrsubnet(var.address_space[1], 8, 3)]
          network_security_group = {
            id = module.nsg["nsg-right"].resource_id
          }
        }
        subnet3 = {
          name             = var.subnet_name[5]
          address_prefixes = [cidrsubnet(var.address_space[1], 8, 5)]
          network_security_group = {
            id = module.nsg["nsg-right"].resource_id
          }
        }
      }
      peerings = var.enable_peering ? {
        peertovnet1 = {
          remote_virtual_network_resource_id = local.vnet_resource_id
          name                               = "snet1-2-right-TO-${var.subnet_name[0]}"
          allow_forwarded_traffic            = true
          allow_virtual_network_access       = true
          allow_gateway_transit              = false
          peer_complete_vnets                = false
          local_peered_subnets = [
            {
              subnet_name = var.subnet_name[3]
            },
            {
              subnet_name = var.subnet_name[4]
            }
          ]
          remote_peered_subnets = [
            {
              subnet_name = var.subnet_name[0]
            }
          ]
          create_reverse_peering               = true
          reverse_name                         = "${var.subnet_name[0]}-TO-snet1-2-right"
          reverse_allow_forwarded_traffic      = true
          reverse_allow_virtual_network_access = true
          reverse_allow_gateway_transit        = false
          reverse_peer_complete_vnets          = false
          reverse_local_peered_subnets = [
            {
              subnet_name = var.subnet_name[0]
            }
          ]
          reverse_remote_peered_subnets = [
            {
              subnet_name = var.subnet_name[3]
            },
            {
              subnet_name = var.subnet_name[4]
            }
          ]
        }
      } : {}
    }
  }

  #-------------------------------------------------------------------------------------------------------------------------------
  # Bastion - This section defines the Bastion hosts for both virtual networks
  #-------------------------------------------------------------------------------------------------------------------------------
  bastion = {
    bastion1 = {
      name               = var.bastion_name[0]
      virtual_network_id = module.vnet["vnet1"].resource_id
    }
    bastion2 = {
      name               = var.bastion_name[1]
      virtual_network_id = module.vnet["vnet2"].resource_id
    }
  }

  #-------------------------------------------------------------------------------------------------------------------------------
  # VMs - This section defines the virtual machines and their configurations
  #-------------------------------------------------------------------------------------------------------------------------------
  vms = {
    for i in range(6) :
    "vm${i + 1}" => {
      name                          = var.subnet_name[i]
      nic_name                      = var.subnet_name[i]
      private_ip_subnet_resource_id = module.vnet[i < 3 ? "vnet1" : "vnet2"].subnets["subnet${(i % 3) + 1}"].resource_id
      os_disk_name                  = var.subnet_name[i]
    }
  }
}
