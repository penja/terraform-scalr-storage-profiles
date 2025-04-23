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

## Quick Start

### AWS S3

```hcl
module "aws_s3_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-aws-s3"

  bucket_name        = "my-scalr-state-bucket"
  scalr_account_name = "my-scalr-account"

  # Optional parameters
  aws_region           = "us-west-2"
  storage_profile_name = "my-custom-storage-profile"
}
```

### Google Cloud Storage

```hcl
module "google_storage_profile" {
  source = "github.com/scalr/terraform-scalr-storage-profiles//modules/terraform-scalr-storage-profile-google-cloud-storage"

  bucket_name        = "my-scalr-state-bucket"
  google_project     = "my-google-project"
  scalr_account_name = "my-scalr-account"


  # Optional parameters
  google_region         = "US"
  storage_profile_name  = "my-custom-storage-profile"
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
