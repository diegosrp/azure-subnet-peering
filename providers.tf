# Define the provider blocks according to your preferred configuration settings
provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {}

provider "tls" {}

provider "null" {}

provider "random" {}
