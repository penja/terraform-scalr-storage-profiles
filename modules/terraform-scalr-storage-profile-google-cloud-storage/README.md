# Google Cloud Storage Profile for Scalr

This Terraform module creates and configures Google Cloud resources required for a Scalr storage profile using Google Cloud Storage.

## Features

- Creates a Google Cloud Storage bucket for storing Terraform/OpenTofu state files
- Sets up a service account with appropriate permissions
- Provides instructions for using the Scalr CLI to create the storage profile in Scalr

## Usage

```hcl
module "google_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-google-cloud-storage"

  bucket_name        = "my-scalr-state-bucket"
  google_project     = "my-google-project"
  scalr_account_name = "my-scalr-account"
}
```

## Inputs

| Name                 | Description                                                                                                                                                                  | Type     | Default                          | Required |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|----------------------------------|----------|
| bucket_name          | The name of the Google Cloud Storage bucket to use for the blob backend                                                                                                      | `string` | n/a                              | yes      |
| google_project       | The Google Cloud project ID where the bucket will be created                                                                                                                 | `string` | n/a                              | yes      |
| scalr_account_name   | Scalr account name                                                                                                                                                           | `string` | n/a                              | yes      |
| scalr_hostname       | The hostname of the Scalr server                                                                                                                                             | `string` | `"scalr.io"`                     | no       |
| force_destroy        | Force destroy the Google Cloud Storage bucket                                                                                                                                | `bool`   | `false`                          | no       |
| storage_profile_name | Name for the storage profile in Scalr                                                                                                                                        | `string` | `"google-cloud-storage-profile"` | no       |
| enable_versioning    | Enable versioning for Google Cloud Storage bucket                                                                                                                            | `bool`   | `true`                           | no       |
| google_region        | The Google Cloud region where the bucket will be created                                                                                                                     | `string` | `"us-east1"`                     | no       |

## Outputs

| Name                         | Description                                                                    |
|------------------------------|--------------------------------------------------------------------------------|
| google_storage_bucket_name   | The name of the Google Cloud Storage bucket                                    |
| google_storage_bucket_url    | The URL of the Google Cloud Storage bucket                                     |
| google_service_account_email | The email of the service account                                               |
| google_service_account_key   | The service account key (sensitive)                                            |
| scalr_cli_instructions | Instructions for installing and configuring the Scalr CLI to create a storage profile in Scalr |

## Creating the Storage Profile in Scalr

After applying this module, you can use the `scalr_cli_instructions` output to create the storage profile in Scalr. This output provides step-by-step instructions for installing and configuring the Scalr CLI, and then using it to create a storage profile in your Scalr account using the Google Cloud Storage backend.

## Creating a Module in Scalr

To use this module in Scalr, follow these steps:
1. Fork the repository `https://github.com/scalr/terraform-scalr-storage-profiles` with tags
2. In your Scalr account, navigate to the Modules section
3. Click "Add Module"
4. Select the forked repository from the list
5. Set the module path to `modules/terraform-scalr-storage-profile-google-cloud-storage`
6. Click "Add Module"

## Creating a Module-Driven Workspace

After adding the module to Scalr, you can create a workspace based on it:

1. Navigate to the Workspaces section
2. Click "Create Workspace"
3. Select "Module-driven" as the workspace type
4. Choose the Google Cloud Storage Profile module you added earlier
5. Click "Create Workspace"
6. Configure the required variables:
   - `bucket_name`: The name of the Google Cloud Storage bucket to create
   - `google_project`: Your Google Cloud project ID
   - `scalr_account_name`: Your Scalr account name
7. Configure any optional variables as needed
8. Run the workspace to create the Google Cloud resources and storage profile
9. Use the `scalr_cli_instructions` output to create the storage profile in Scalr, following the security best practices described above
