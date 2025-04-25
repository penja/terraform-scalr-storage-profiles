# Azure Resource Manager Storage Profile for Scalr

This module creates and configures Azure resources required for a Scalr storage profile:

- Azure Resource Group
- Azure Storage Account for storing Terraform/OpenTofu state files
- Azure Storage Container
- Ready-to-use Scalr CLI instructions to create the storage profile in Scalr

**Note:** This module does not create Azure AD resources. You must create an Azure AD application and set up federated credentials manually. See the "Setting Up Azure AD Federated Credentials" section below for instructions.

## Usage

```hcl
module "azurerm_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-azurerm"

  storage_account_name                  = "scalrstate"
  tenant_id                             = "f41d62f5-bc6a-4996-a3a1-3876f337a47b"
  scalr_account_name                    = "your-scalr-account"
  existing_storage_profile_application_id = "00000000-0000-0000-0000-000000000000"  # Replace with your existing application ID

  # Optional parameters
  resource_group_name  = "scalr-storage-profile-rg"
  azure_location       = "eastus"
  container_name       = "tfstate"
  storage_profile_name = "azure-rm-storage-profile"
  oidc_audience_value  = "azure-rm-scalr-run-workload"
  scalr_hostname       = "scalr.io"
}
```

### Setting Up Azure AD Federated Credentials

This module requires an existing Azure AD application with federated credentials for workload identity federation. This allows Scalr to authenticate to Azure without using a client secret, which is more secure.

To set up an Azure AD application with federated credentials for use with this module, follow these steps:

1. **Create an Azure AD Application**:
   - In the Azure Portal, navigate to Azure Active Directory > App registrations > New registration.
   - Enter a name for the application (e.g., "Scalr Storage Profile").
   - Select the appropriate supported account types.
   - Click "Register".
   - After the application is created, note the Application (client) ID. You'll need this for the `existing_storage_profile_application_id` variable.

3. **Set Up Federated Credentials**:
   - In the Azure Portal, navigate to Azure Active Directory > App registrations > [Your App] > Certificates & secrets > Federated credentials.
   - Click "Add credential".
   - Select "Other issuer" as the federated credential scenario.
   - Enter the following details:
     - Issuer: `https://<scalr_hostname>` (default: `https://scalr.io`)
     - Subject identifier: `scalr:account:<scalr_account_name>` (replace `<scalr_account_name>` with your Scalr account name)
     - Name: A descriptive name for the credential (e.g., "Scalr-Federated-Credential")
     - Audience: The value you'll use for the `oidc_audience_value` variable (default: `azure-rm-scalr-run-workload`)
   - Click "Add".

4. **Grant Storage Blob Data Contributor Access**:
   - After running this module to create the storage account https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Storage%2FStorageAccounts, you'll need to grant the service principal access to the storage account. 
   - In the Azure Portal, navigate to the storage account created by this module.
   - Go to Access Control (IAM) > Add > Add role assignment.
   - Select the "Storage Blob Data Contributor" role.
   - Assign access to "User, group, or service principal".
   - Search for and select the service principal you created.
   - Click "Review + assign".

5. **Configure Scalr Storage Profile**:
   - After running this module, use the `scalr_cli_instructions` output to create a storage profile in Scalr.

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.0.0 |
| azurerm   | >= 3.0.0 |

## Providers

| Name    | Version  |
|---------|----------|
| azurerm | >= 3.0.0 |

## Inputs

| Name                                    | Description                                                            | Type     | Default                         | Required |
|-----------------------------------------|------------------------------------------------------------------------|----------|---------------------------------|:--------:|
| resource_group_name                     | The name of the Azure Resource Group where resources will be created   | `string` | `"scalr-storage-profile-rg"`    |    no    |
| azure_location                          | The Azure location where resources will be created                     | `string` | `"eastus"`                      |    no    |
| storage_account_name                    | The name of the Azure Storage Account to use for the blob backend      | `string` | n/a                             |   yes    |
| container_name                          | The name of the Azure Storage Container to use for the blob backend    | `string` | `"tfstate"`                     |    no    |
| enable_versioning                       | Enable versioning for Azure Storage Account                            | `bool`   | `true`                          |    no    |
| scalr_hostname                          | The hostname of the Scalr server                                       | `string` | `"scalr.io"`                    |    no    |
| scalr_account_name                      | Scalr account name                                                     | `string` | n/a                             |   yes    |
| storage_profile_name                    | Name for the storage profile in Scalr                                  | `string` | `"azure-rm-storage-profile"`    |    no    |
| tenant_id                               | The Azure AD tenant ID                                                 | `string` | n/a                             |   yes    |
| oidc_audience_value                     | The audience value for Azure authentication                            | `string` | `"azure-rm-scalr-run-workload"` |    no    |
| existing_storage_profile_application_id | Existing Azure AD application client ID to use for the storage profile | `string` | n/a                             |   yes    |

## Outputs

| Name                         | Description                                                                    |
|------------------------------|--------------------------------------------------------------------------------|
| azure_storage_account_name   | The name of the Azure Storage Account                                          |
| azure_storage_container_name | The name of the Azure Storage Container                                        |
| azure_application_id         | The Application ID of the Azure AD application                                 |
| azure_tenant_id              | The Azure AD tenant ID                                                         |
| azure_audience               | The audience value for Azure authentication                                    |
| scalr_cli_instructions | Instructions for installing and configuring the Scalr CLI to create a storage profile in Scalr |

## Creating a Module in Scalr

To use this module in Scalr, follow these steps:
1. Fork the repository `https://github.com/scalr/terraform-scalr-storage-profiles` with tags
2. In your Scalr account, navigate to the Modules section
3. Click "Add Module"
4. Select the forked repository from the list
5. Set the module path to `modules/terraform-scalr-storage-profile-azurerm`
6. Click "Add Module"

## Creating a Module-Driven Workspace

After adding the module to Scalr, you can create a workspace based on it:

1. Navigate to the Workspaces section
2. Click "Create Workspace"
3. Select "Module-driven" as the workspace type
4. Choose the Azure Resource Manager Storage Profile module you added earlier
5. Click "Create Workspace"
6. Configure the required variables:
   - `storage_account_name`: The name of the Azure Storage Account to create
   - `tenant_id`: Your Azure AD tenant ID
   - `scalr_account_name`: Your Scalr account name
   - `existing_storage_profile_application_id`: The Application (client) ID of your Azure AD application
7. Configure any optional variables as needed
8. Run the workspace to create the Azure resources and storage profile
9. Use the `scalr_cli_instructions` output to create the storage profile in Scalr, following the security best practices described above
