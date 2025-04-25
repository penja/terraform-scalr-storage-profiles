variable "scalr_account_name" {
  type        = string
  description = "Scalr account name. This variable is passed to the common module."
}

variable "bucket_name" {
  description = "The name of the s3 storage bucket to use for the blob backend."
  type        = string
}

# --- Optional inputs section

variable "dynamodb_table_name" {
  description = "Custom DynamoDB table name. If not provided, 'tf-locks' name with random suffix will be used."
  type        = string
  default     = null
}

variable "enable_s3_encryption" {
  description = "Enable server-side encryption for S3 bucket"
  type        = bool
  default     = true
}

variable "enable_dynamodb_pitr" {
  description = "Enable Point-in-Time Recovery for DynamoDB table"
  type        = bool
  default     = false
}

variable "scalr_hostname" {
  type        = string
  description = "The hostname of the Scalr server. This is used to configure the OIDC provider in AWS. This variable is passed to the common module."
  default     = "scalr.io"
}

variable "oidc_audience_value" {
  type        = string
  description = "OIDC audience value for AWS authentication"
  default     = "aws.scalr-run-workload"
}

variable "iam_role_name" {
  description = "The name of the IAM role to create for Scalr."
  type        = string
  default     = "scalr-storage-profile-role"
}

variable "force_destroy" {
  description = "Force destroy the S3 bucket"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region where the resources are created"
  type        = string
  default     = "us-east-1"
}

variable "storage_profile_name" {
  description = "Name for the storage profile in Scalr"
  type        = string
  default     = "aws-s3-storage-profile"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "TofuLockTable"
    Environment = "dev"
  }
}