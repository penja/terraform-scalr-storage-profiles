# Terraform Scalr Storage Profiles

This repository contains Terraform modules for creating and configuring storage profiles in Scalr. These modules help you set up the necessary infrastructure for storing Terraform/OpenTofu state files securely.

## Available Modules

### [AWS S3](./modules/aws-s3)

The AWS S3 module creates and configures AWS resources required for a Scalr storage profile:
- S3 bucket for storing Terraform/OpenTofu state files
- DynamoDB table for state locking
- IAM roles and policies for Scalr to access these resources via OIDC
- Ready-to-use curl command to create the storage profile in Scalr

## Quick Start

```hcl
module "aws_s3_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/aws-s3"

  bucket_name        = "my-scalr-state-bucket"
  scalr_account_name = "my-scalr-account"

  # Optional parameters
  aws_region           = "us-west-2"
  storage_profile_name = "my-custom-storage-profile"
}
```

## Requirements

- Terraform >= 0.13.0
- Provider requirements vary by module (see individual module READMEs)
- A Scalr account

## Using Modules in Scalr

### Adding a Module to Scalr

1. In your Scalr account, navigate to the Modules section
2. Click "Add Module"
3. Select "GitHub" or your preferred VCS provider
4. Enter the repository URL: `https://github.com/scalr/terraform-scalr-storage-profiles`
5. Select the branch (usually `main`)
6. Set the module path to the specific module you want to use (e.g., `modules/aws-s3`)
7. Click "Add Module"

### Creating a Module-Driven Workspace

After adding a module to Scalr, you can create a workspace based on it:

1. Navigate to the Workspaces section
2. Click "Create Workspace"
3. Select "Module-driven" as the workspace type
4. Choose the module you added earlier
5. Configure the required variables (see module documentation)
6. Configure any optional variables as needed
7. Click "Create Workspace"
8. Run the workspace to create the resources and storage profile

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
