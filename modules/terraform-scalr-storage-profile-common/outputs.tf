output "scalr_hostname" {
  description = "The hostname of the Scalr server."
  value       = var.scalr_hostname
}

output "scalr_account_name" {
  description = "Scalr account name"
  value       = var.scalr_account_name
}

output "scalr_token" {
  description = "Scalr access token for the curl request."
  value       = var.scalr_token
  sensitive   = true
}