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

locals {
  scalr_cli_command_template = <<-EOT
    scalr create-storage-profile \
      --name "${var.storage_profile_name}" \
      --backend-type azurerm \
      --azurerm-storage-account ${azurerm_storage_account.storage_profile_account.name} \
      --azurerm-container-name ${azurerm_storage_container.storage_profile_container.name} \
      --azurerm-tenant-id ${var.tenant_id} \
      --azurerm-client-id ${var.existing_storage_profile_application_id} \
      --azurerm-audience "${var.oidc_audience_value} \
      --default true
  EOT
}

output "scalr_cli_instructions" {
  description = "Instructions for installing and configuring the Scalr CLI"
  value       = <<-EOT
    # Installation and Configuration Instructions for Scalr CLI

    ## 1. Install Scalr CLI (optional, skip if insalled already)
    # For macOS and Linux:
    # 1. Download the appropriate binary from https://github.com/Scalr/scalr-cli/releases
    #    For macOS, choose the darwin-amd64 or darwin-arm64 version
    #    For Linux, choose the linux-amd64 version
    # 2. Make it executable:
    chmod +x scalr
    # 3. Move it to a directory in your PATH:
    sudo mv scalr /usr/local/bin/
    # 4. For macOS only: If you see a security warning, you need to:
    #    a. Open System Settings > Privacy & Security
    #    b. Click "Allow Anyway" next to the Scalr CLI warning
    #    c. Run the command again and click "Open" in the security dialog
    # 5. Verify installation:
    scalr --version

    ## 2. Configure Scalr CLI
    # Run the configure command and follow the prompts:
    scalr -configure

    # You'll need to provide:
    # - Scalr hostname: ${var.scalr_hostname}
    # - Account name: ${var.scalr_account_name}
    # - Access token: (your Scalr access token)

    ## 3. Verify Configuration
    # Test your configuration:
    scalr ping

    ## 4. Create Storage Profile
    # After installation and configuration, you can create the storage profile using:
    ${local.scalr_cli_command_template}
  EOT
}

