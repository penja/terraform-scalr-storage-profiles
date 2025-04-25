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

locals {
  scalr_cli_command_template = <<-EOT
    scalr create-storage-profile \
      --name "${var.storage_profile_name}" \
      --backend-type google \
      --google-storage-bucket ${google_storage_bucket.storage-profile-bucket.name} \
      --google-project ${var.google_project} \
      --google-credentials "${base64decode(nonsensitive(google_service_account_key.scalr_service_account_key.private_key))}" \
      --default true
  EOT
}

output "scalr_cli_instructions" {
  description = "Instructions for installing and configuring the Scalr CLI"
  value       = <<-EOT
    # Installation and Configuration Instructions for Scalr CLI

    ## 1. Install Scalr CLI (optional, skip if insalled already)
    # For macOS and Linux:
    # 1. Download the appropriate binary from https://github.com/Scalr/scalr-cli/releases
    #    For macOS, choose the darwin-amd64 or darwin-arm64 version
    #    For Linux, choose the linux-amd64 version
    # 2. Make it executable:
    chmod +x scalr
    # 3. Move it to a directory in your PATH:
    sudo mv scalr /usr/local/bin/
    # 4. For macOS only: If you see a security warning, you need to:
    #    a. Open System Settings > Privacy & Security
    #    b. Click "Allow Anyway" next to the Scalr CLI warning
    #    c. Run the command again and click "Open" in the security dialog
    # 5. Verify installation:
    scalr --version

    ## 2. Configure Scalr CLI
    # Run the configure command and follow the prompts:
    scalr -configure

    # You'll need to provide:
    # - Scalr hostname: ${var.scalr_hostname}
    # - Account name: ${var.scalr_account_name}
    # - Access token: (your Scalr access token)

    ## 3. Verify Configuration
    # Test your configuration:
    scalr ping

    ## 4. Create Storage Profile
    # After installation and configuration, you can create the storage profile using:
    ${local.scalr_cli_command_template}
  EOT
}