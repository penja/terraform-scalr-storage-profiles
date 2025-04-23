provider "azurerm" {
  tenant_id       = var.tenant_id
  features        = {}
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

# Create an Azure AD application for Scalr
resource "azuread_application" "scalr_app" {
  display_name = "scalr-storage-profile-app"
}

# Create a service principal for the application
resource "azuread_service_principal" "scalr_sp" {
   client_id = azuread_application.scalr_app.client_id
}

# Create a role assignment to grant the service principal access to the storage account
resource "azurerm_role_assignment" "storage_blob_contributor" {
  scope                = azurerm_storage_account.storage_profile_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.scalr_sp.id
}

# Create federated credentials for each environment
resource "azuread_application_federated_identity_credential" "scalr_federated_credentials" {
  application_id = azuread_application.scalr_app.id
  display_name   = "scalr-federated-credentials-${var.scalr_hostname}"
  description    = "Federated credential for Scalr Storage Profile"
  audiences      = [var.oidc_audience_value]
  issuer         = "https://${var.scalr_hostname}"
  subject        = "account:${var.scalr_account_name}"
}
