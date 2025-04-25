# AWS S3 Storage Profile for Scalr

This Terraform module creates and configures AWS resources required for a Scalr storage profile using S3.


## Features

- Creates an S3 bucket for storing Terraform/OpenTofu state files
- Configures IAM roles and policies for Scalr to access these resources via OIDC
- Automatically detects and uses existing OIDC provider or creates a new one
- Provides instructions for using the Scalr CLI to create the storage profile in Scalr

## Usage

```hcl
module "aws_s3_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-aws-s3"

  bucket_name        = "my-scalr-state-bucket"
  scalr_account_name = "my-scalr-account"
  oidc_audience_value = "aws.my-awsone-audience-value"

  # Optional parameters
  aws_region           = "us-west-2"
  storage_profile_name = "my-custom-storage-profile"
}
```

## Inputs

| Name                 | Description                                                                                                                                                                  | Type     | Default                        | Required |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|--------------------------------|----------|
| bucket_name          | The name of the s3 storage bucket to use for the blob backend                                                                                                                | `string` | n/a                            | yes      |
| scalr_account_name   | Scalr account name                                                                                                                                                           | `string` | n/a                            | yes      |
| enable_s3_encryption | Enable server-side encryption for S3 bucket                                                                                                                                  | `bool`   | `true`                         | no       |
| scalr_hostname       | The hostname of the Scalr server                                                                                                                                             | `string` | `"scalr.io"`                   | no       |
| oidc_audience_value  | OIDC audience value                                                                                                                                                          | `string` | `"aws.scalr-run-workload"`     | no       |
| iam_role_name        | The name of the IAM role to create for Scalr                                                                                                                                 | `string` | `"scalr-storage-profile-role"` | no       |
| force_destroy        | Force destroy the S3 bucket                                                                                                                                                  | `bool`   | `false`                        | no       |
| aws_region           | AWS region where the resources are created                                                                                                                                   | `string` | `"us-east-1"`                  | no       |
| storage_profile_name | Name for the storage profile in Scalr                                                                                                                                        | `string` | `"aws-s3-storage-profile"`     | no       |

## Outputs

| Name                  | Description                                                                     |
|-----------------------|---------------------------------------------------------------------------------|
| aws_s3_bucket_name    | The name of the S3 bucket                                                       |
| aws_s3_bucket_arn     | The ARN of the S3 bucket                                                        |
| aws_iam_role_arn      | The ARN of the IAM role                                                         |
| aws_s3_audience       | The OIDC audience value for AWS S3                                              |
| scalr_cli_instructions | Instructions for installing and configuring the Scalr CLI to create a storage profile in Scalr |

## OIDC Provider Handling

The module automatically handles OIDC provider configuration:

1. Checks for an existing OIDC provider for your Scalr hostname
2. If found, uses the existing provider
3. If not found, creates a new provider with the correct configuration
4. Uses the provider's ARN for IAM role configuration

This ensures seamless operation whether you're:
- Setting up a new environment
- Using an existing OIDC provider
- Working with multiple Scalr instances

## Creating the Storage Profile in Scalr

After applying this module, you can use the `scalr_cli_instructions` output to create the storage profile in Scalr. This output provides step-by-step instructions for installing and configuring the Scalr CLI, and then using it to create a storage profile in your Scalr account using the AWS S3 backend.


## Creating a Module in Scalr

To use this module in Scalr, follow these steps:
1. Fork the repository `https://github.com/scalr/terraform-scalr-storage-profiles` with tags
2. In your Scalr account, navigate to the Modules section
3. Click "Add Module"
4. Select the forked repository from the list
5. Set the module path to `modules/terraform-scalr-storage-profile-aws-s3`
6. Click "Add Module"

## Creating a Module-Driven Workspace

After adding the module to Scalr, you can create a workspace based on it:

1. Navigate to the Workspaces section
2. Click "Create Workspace"
3. Select "Module-driven" as the workspace type
4. Choose the AWS S3 Storage Profile module you added earlier
5. Click "Create Workspace"
6. Configure the required variables:
   - `bucket_name`: The name of the S3 bucket to create
   - `scalr_account_name`: Your Scalr account name
7. Configure any optional variables as needed
8. Run the workspace to create the AWS resources and storage profile
9. Use the `scalr_cli_instructions` output to create the storage profile in Scalr, following the security best practices described above
