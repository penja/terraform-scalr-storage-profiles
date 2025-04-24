output "azure_storage_account_name" {
  description = "The name of the Azure Storage Account"
  value       = azurerm_storage_account.storage_profile_account.name
}

output "azure_storage_container_name" {
  description = "The name of the Azure Storage Container"
  value       = azurerm_storage_container.storage_profile_container.name
}

output "azure_application_id" {
  description = "The Application ID of the Azure AD application"
  value       = var.existing_storage_profile_application_id
}

output "azure_tenant_id" {
  description = "The Azure AD tenant ID"
  value       = var.tenant_id
}

output "azure_audience" {
  description = "The audience value for Azure authentication"
  value       = var.oidc_audience_value
}

output "scalr_hostname" {
  description = "The hostname of the Scalr server."
  value       = var.scalr_hostname
}

output "scalr_account_name" {
  description = "Scalr account name"
  value       = var.scalr_account_name
}

output "scalr_token" {
  description = "Scalr access token for the curl request."
  value       = var.scalr_token
  sensitive   = true
}

output "curl_command_template" {
  description = "Template for curl command to create a storage profile in Scalr (requires your own token)"
  value       = <<-EOT
    curl -X POST "https://${var.scalr_account_name}.${var.scalr_hostname}/api/iacp/v3/storage-profiles" \
      -H "Authorization: Bearer ${nonsensitive(var.scalr_token)}" \
      -H "Content-Type: application/vnd.api+json" \
      -d '{
        "data": {
          "type": "storage-profiles",
          "attributes": {
            "backend-type": "azurerm",
            "name": "${var.storage_profile_name}",
            "default": true,
            "azurerm-storage-account": "${azurerm_storage_account.storage_profile_account.name}",
            "azurerm-container-name": "${azurerm_storage_container.storage_profile_container.name}",
            "azurerm-tenant-id": "${var.tenant_id}",
            "azurerm-client-id": "${var.existing_storage_profile_application_id}",
            "azurerm-audience": "${var.oidc_audience_value}",
          }
        }
      }'
  EOT
}
