output "google_storage_bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  value       = google_storage_bucket.storage-profile-bucket.name
}

output "google_storage_bucket_url" {
  description = "The URL of the Google Cloud Storage bucket"
  value       = google_storage_bucket.storage-profile-bucket.url
}

output "google_service_account_email" {
  description = "The email of the service account"
  value       = google_service_account.scalr_service_account.email
}

output "google_service_account_key" {
  description = "The service account key (sensitive)"
  value       = google_service_account_key.scalr_service_account_key.private_key
  sensitive   = true
}

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

output "curl_command_template" {
  description = "Template for curl command to create a storage profile in Scalr (requires your own token)"
  value       = <<-EOT
    curl -X POST "https://${var.scalr_account_name}.${var.scalr_hostname}/api/iacp/v3/storage-profiles" \
      -H "Authorization: Bearer ${nonsensitive(var.scalr_token)}" \
      -H "Content-Type: application/vnd.api+json" \
      -d '{
        "data": {
          "type": "storage-profiles",
          "attributes": {
            "backend-type": "google",
            "default": true,
            "name": "${var.storage_profile_name}",
            "google-storage-bucket": "${google_storage_bucket.storage-profile-bucket.name}",
            "google-project": "${var.google_project}",
            "google-credentials": ${base64decode(nonsensitive(google_service_account_key.scalr_service_account_key.private_key))}
          }
        }
      }'
  EOT
}
