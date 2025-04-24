# Terraform Scalr Storage Profiles

This repository contains Terraform modules for creating and configuring storage profiles in Scalr. These modules help you set up the necessary infrastructure for storing Terraform/OpenTofu state files securely.


## Available Modules


### [AWS S3](./modules/terraform-scalr-storage-profile-aws-s3)

The AWS S3 module creates and configures AWS resources required for a Scalr storage profile:
- S3 bucket for storing Terraform/OpenTofu state files
- DynamoDB table for state locking
- IAM roles and policies for Scalr to access these resources via OIDC
- Ready-to-use curl command to create the storage profile in Scalr

### [Google Cloud Storage](./modules/terraform-scalr-storage-profile-google-cloud-storage)

The Google Cloud Storage module creates and configures Google Cloud resources required for a Scalr storage profile:
- Google Cloud Storage bucket for storing Terraform/OpenTofu state files
- Service account with appropriate permissions
- Ready-to-use curl command to create the storage profile in Scalr

### [Azure Resource Manager](./modules/terraform-scalr-storage-profile-azurerm)

The Azure Resource Manager module creates and configures Azure resources required for a Scalr storage profile:
- Azure Storage Account for storing Terraform/OpenTofu state files
- Azure Storage Container
- Ready-to-use curl command to create the storage profile in Scalr

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
