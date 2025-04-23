variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket to use for the blob backend."
  type        = string
}

variable "google_project" {
  description = "The Google Cloud project ID where the bucket will be created."
  type        = string
}

variable "google_region" {
  description = "The Google Cloud region where the bucket will be created."
  type        = string
  default     = "us-east1"
}

variable "scalr_hostname" {
  type        = string
  description = "The hostname of the Scalr server."
  default     = "scalr.io"
}

variable "scalr_account_name" {
  type        = string
  description = "Scalr account name"
}

variable "scalr_token" {
  type        = string
  description = "Optional Scalr access token for the curl request. For security, do not hardcode this value in your configuration. Use environment variables or other secure methods instead."
  default     = null
  sensitive   = true
}

variable "force_destroy" {
  description = "Force destroy the Google Cloud Storage bucket"
  type        = bool
  default     = false
}

variable "storage_profile_name" {
  description = "Name for the storage profile in Scalr"
  type        = string
  default     = "google-cloud-storage-profile"
}

variable "enable_versioning" {
  description = "Enable versioning for Google Cloud Storage bucket"
  type        = bool
  default     = true
}