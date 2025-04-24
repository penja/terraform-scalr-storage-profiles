provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = var.tenant_id
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
  storage_account_id = azurerm_storage_account.storage_profile_account.id
  container_access_type = "private"
}

# Get the service principal by client ID
data "azuread_service_principal" "storage_profile_sp" {
  count        = var.create_role_assignment ? 1 : 0
  client_id    = var.existing_storage_profile_application_id
}

# Grant Storage Blob Data Contributor access to the service principal
resource "azurerm_role_assignment" "storage_blob_contributor" {
  count                = var.create_role_assignment ? 1 : 0
  scope                = azurerm_storage_account.storage_profile_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_service_principal.storage_profile_sp[0].id
}
