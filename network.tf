# Ensure the Azure feature 'AllowMultiplePeeringLinksBetweenVnets' is registered
resource "null_resource" "register_multiple_peering_feature" {
  provisioner "local-exec" {
    command     = <<EOT
      set -e
      echo "Checking if the Azure feature 'AllowMultiplePeeringLinksBetweenVnets' is registered.."
      state=$(az feature show --name AllowMultiplePeeringLinksBetweenVnets --namespace Microsoft.Network --query 'properties.state' -o tsv)
      if [ "$state" != "Registered" ]; then
        echo "Feature not registered. Registering now..."
        az feature register --namespace Microsoft.Network --name AllowMultiplePeeringLinksBetweenVnets
        echo "Waiting for the feature to be registered (this may take a few minutes).."
        while [ "$state" != "Registered" ]; do
          sleep 10
          state=$(az feature show --name AllowMultiplePeeringLinksBetweenVnets --namespace Microsoft.Network --query 'properties.state' -o tsv)
        done
        echo "Feature successfully registered."
      else
        echo "Feature already registered."
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

# Creating a Resource Group
module "rg" {
  source  = "azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  name     = var.rg_name
  location = var.default_location

  tags             = var.tags
  enable_telemetry = false
}

# Creating Network Security Groups
module "nsg" {
  source  = "azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.0"

  for_each = toset(var.nsg_name)

  resource_group_name = module.rg.name
  location            = module.rg.resource["location"]

  name = each.value

  enable_telemetry = false
  tags             = var.tags
}

# Creating Virtual Networks
module "vnet" {
  source  = "azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.10.0"

  for_each = local.vnet

  resource_group_name = module.rg.name
  location            = module.rg.resource["location"]

  name          = each.value.name
  address_space = each.value.address_space
  subnets       = each.value.subnets
  peerings      = each.value.peerings

  enable_telemetry = false
  tags             = var.tags

  depends_on = [null_resource.register_multiple_peering_feature]
}

# Creating Bastion Hosts
module "bastion" {
  source  = "azure/avm-res-network-bastionhost/azurerm"
  version = "0.8.1"

  for_each = local.bastion

  resource_group_name = module.rg.name
  location            = module.rg.resource["location"]
  virtual_network_id  = each.value.virtual_network_id

  name  = each.value.name
  sku   = "Developer"
  zones = []

  enable_telemetry = false
  tags             = var.tags

  depends_on = [module.vnet]
}
