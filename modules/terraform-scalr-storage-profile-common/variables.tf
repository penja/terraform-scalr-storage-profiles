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