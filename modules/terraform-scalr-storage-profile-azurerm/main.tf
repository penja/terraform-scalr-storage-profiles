terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.27"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "storage_profile_rg" {
  name     = var.resource_group_name
  location = var.azure_location
}

resource "azurerm_storage_account" "storage_profile_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_profile_rg.name
  location                 = azurerm_resource_group.storage_profile_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = var.enable_versioning
  }

  tags = {
    name        = "tofu-state-storage"
    environment = "dev"
  }
}

resource "azurerm_storage_container" "storage_profile_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage_profile_account.id
  container_access_type = "private"
}
