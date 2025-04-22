# AWS S3 Storage Profile for Scalr

This Terraform module creates and configures AWS resources required for a Scalr storage profile using S3 and DynamoDB.


## Features

- Creates an S3 bucket for storing Terraform/OpenTofu state files
- Sets up a DynamoDB table for state locking
- Configures IAM roles and policies for Scalr to access these resources via OIDC
- Provides a ready-to-use curl command to create the storage profile in Scalr

## Requirements

- Forked AWS provider (scalr/aws)
- TLS provider
- Random provider
- An AWS account with appropriate permissions
- A Scalr account

## Usage

```hcl
module "aws_s3_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-aws-s3"

  bucket_name        = "my-scalr-state-bucket"
  scalr_account_name = "my-scalr-account"

  # Optional parameters
  aws_region         = "us-west-2"
  storage_profile_name = "my-custom-storage-profile"
  scalr_token        = "your-scalr-api-token" # Optional: Token for the curl command
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | The name of the s3 storage bucket to use for the blob backend | `string` | n/a | yes |
| scalr_account_name | Scalr account name | `string` | n/a | yes |
| dynamodb_table_name | Custom DynamoDB table name. If not provided, 'tf-locks' name with random suffix will be used | `string` | `null` | no |
| enable_s3_encryption | Enable server-side encryption for S3 bucket | `bool` | `true` | no |
| enable_dynamodb_pitr | Enable Point-in-Time Recovery for DynamoDB table | `bool` | `false` | no |
| scalr_hostname | The hostname of the Scalr server | `string` | `"scalr.io"` | no |
| oidc_audience_value | OIDC audience value | `string` | `"aws.scalr-run-workload"` | no |
| iam_role_name | The name of the IAM role to create for Scalr | `string` | `"scalr-storage-profile-role"` | no |
| force_destroy | Force destroy the S3 bucket | `bool` | `false` | no |
| aws_region | AWS region where the resources are created | `string` | `"us-east-1"` | no |
| storage_profile_name | Name for the storage profile in Scalr | `string` | `"aws-s3-ape-storage-profile"` | no |
| scalr_token | Optional scalr access token for the curl request | `string` | `" put your token here"` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_s3_bucket_name | The name of the S3 bucket |
| aws_s3_bucket_arn | The ARN of the S3 bucket |
| aws_s3_audience | The OIDC audience value for AWS S3 |
| curl_command | Curl command to create a storage profile in Scalr |

## Creating the Storage Profile in Scalr

After applying this module, you can use the `curl_command` output to create the storage profile in Scalr:

```bash
# The curl command will use the token provided in the scalr_token variable
eval $(terraform output -raw curl_command)
```

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
5. Configure the required variables:
   - `bucket_name`: The name of the S3 bucket to create
   - `scalr_account_name`: Your Scalr account name
6. Configure any optional variables as needed
7. Click "Create Workspace"
8. Run the workspace to create the AWS resources and storage profile
9. Use the `curl_command` output to create the storage profile in Scalr

