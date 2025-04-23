# Azure Resource Manager Storage Profile for Scalr

This module creates and configures Azure resources required for a Scalr storage profile:

- Azure Resource Group
- Azure Storage Account for storing Terraform/OpenTofu state files
- Azure Storage Container
- Azure AD application and service principal with appropriate permissions
- Ready-to-use curl command to create the storage profile in Scalr

## Usage

```hcl
module "azurerm_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-azurerm"

  storage_account_name = "scalrstate"
  tenant_id            = "f41d62f5-bc6a-4996-a3a1-3876f337a47b"
  scalr_account_name   = "your-scalr-account"
  
  # Optional parameters
  resource_group_name  = "scalr-storage-profile-rg"
  azure_location       = "eastus"
  container_name       = "tfstate"
  storage_profile_name = "azure-rm-storage-profile"
  audience             = "azure-rm-scalr-run-workload"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0.0 |
| azuread | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0.0 |
| azuread | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | The name of the Azure Resource Group where resources will be created | `string` | `"scalr-storage-profile-rg"` | no |
| azure_location | The Azure location where resources will be created | `string` | `"eastus"` | no |
| storage_account_name | The name of the Azure Storage Account to use for the blob backend | `string` | n/a | yes |
| container_name | The name of the Azure Storage Container to use for the blob backend | `string` | `"tfstate"` | no |
| enable_versioning | Enable versioning for Azure Storage Account | `bool` | `true` | no |
| scalr_hostname | The hostname of the Scalr server | `string` | `"scalr.io"` | no |
| scalr_account_name | Scalr account name | `string` | n/a | yes |
| scalr_token | Optional Scalr access token for the curl request | `string` | `null` | no |
| storage_profile_name | Name for the storage profile in Scalr | `string` | `"azure-rm-storage-profile"` | no |
| tenant_id | The Azure AD tenant ID | `string` | n/a | yes |
| audience | The audience value for Azure authentication | `string` | `"azure-rm-scalr-run-workload"` | no |

## Outputs

| Name | Description |
|------|-------------|
| azure_storage_account_name | The name of the Azure Storage Account |
| azure_storage_container_name | The name of the Azure Storage Container |
| azure_application_id | The Application ID of the Azure AD application |
| azure_tenant_id | The Azure AD tenant ID |
| azure_audience | The audience value for Azure authentication |
| curl_command_template | Template for curl command to create a storage profile in Scalr |