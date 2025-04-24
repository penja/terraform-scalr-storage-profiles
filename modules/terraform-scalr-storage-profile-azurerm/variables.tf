variable "resource_group_name" {
  description = "The name of the Azure Resource Group where resources will be created."
  type        = string
  default     = "scalr-storage-profile-rg"
}

variable "azure_location" {
  description = "The Azure location where resources will be created."
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account to use for the blob backend."
  type        = string
}

variable "container_name" {
  description = "The name of the Azure Storage Container to use for the blob backend."
  type        = string
  default     = "tfstate"
}

variable "enable_versioning" {
  description = "Enable versioning for Azure Storage Account"
  type        = bool
  default     = true
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
  default     = "Super secret token"
  sensitive   = true
}

variable "storage_profile_name" {
  description = "Name for the storage profile in Scalr"
  type        = string
  default     = "azure-rm-storage-profile"
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "oidc_audience_value" {
  description = "The audience value for Azure authentication"
  type        = string
  default     = "azure-rm-scalr-run-workload"
}

variable "existing_storage_profile_application_id" {
  description = "Existing Azure AD application client ID to use for the storage profile"
  type        = string
}
