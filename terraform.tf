terraform {
  # Terraform version
  required_version = "1.12.2"

  # Provider version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "2.5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
