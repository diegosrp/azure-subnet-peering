# Ensure the Azure feature 'EncryptionAtHost' is registered
resource "null_resource" "register_encryption_at_host_feature" {
  provisioner "local-exec" {
    command     = <<EOT
      set -e
      echo "Checking if the Azure feature: 'EncryptionAtHost' is registered.."
      state=$(az feature show --name EncryptionAtHost --namespace Microsoft.Compute --query 'properties.state' -o tsv)
      if [ "$state" != "Registered" ]; then
        echo "Feature not registered. Registering now..."
        az feature register --namespace Microsoft.Compute --name EncryptionAtHost
        echo "Waiting for the feature to be registered (this may take a few minutes).."
        while [ "$state" != "Registered" ]; do
          sleep 10
          state=$(az feature show --name EncryptionAtHost --namespace Microsoft.Compute --query 'properties.state' -o tsv)
        done
        echo "Feature successfully registered."
      else
        echo "Feature already registered."
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

# Get the SKUs for the Virtual Machine
module "vm_sku" {
  source  = "azure/avm-utl-sku-finder/azapi"
  version = "0.3.0"

  location = module.rg.resource["location"]

  cache_results = false
  vm_filters = {
    min_vcpus                      = 2
    max_vcpus                      = 2
    min_memory_gb                  = 4
    max_memory_gb                  = 8
    location_zone                  = "1"
    accelerated_networking_enabled = true
    encryption_at_host_supported   = true
    premium_io_supported           = true
  }

  enable_telemetry = false
}

# Generate SSH key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a random string for resource names
resource "random_string" "random_suffix" {
  length  = 10
  numeric = true
  lower   = false
  special = false
  upper   = false
}

# Creating a Key Vault
module "kv" {
  source  = "azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.1"

  resource_group_name = module.rg.name
  location            = module.rg.resource["location"]
  tenant_id           = data.azurerm_client_config.current.tenant_id

  name                     = "kv${random_string.random_suffix.result}"
  purge_protection_enabled = false

  secrets = {
    vms_secret = {
      name = var.private_key_name
    }
  }

  secrets_value = {
    vms_secret = tls_private_key.this.private_key_pem
  }

  network_acls = {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  role_assignments = {
    deployment_user_secrets = { # give the deployment user access to secrets
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }

  enable_telemetry = false
  tags             = var.tags
}

# Creating Virtual Machines
module "vm" {
  source  = "azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.19.3"

  for_each = local.vms

  resource_group_name = module.rg.name
  location            = module.rg.resource["location"]
  sku_size            = module.vm_sku.sku

  name = "vm-${each.value.name}"

  network_interfaces = {
    nic1 = {
      name = "vm-${each.value.nic_name}"
      ip_configurations = {
        ipconfig1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = each.value.private_ip_subnet_resource_id
        }
      }
    }
  }

  encryption_at_host_enabled = true
  os_disk = {
    name                 = "vm-${each.value.os_disk_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  zone    = "1"
  os_type = "Linux"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  account_credentials = {
    admin_credentials = {
      username                           = var.vm_admin_user
      ssh_keys                           = [tls_private_key.this.public_key_openssh]
      generate_admin_password_or_ssh_key = false
      disable_password_authentication    = true
    }
  }

  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = []
  }

  enable_telemetry = false
  tags             = var.tags

  depends_on = [null_resource.register_encryption_at_host_feature]
}
