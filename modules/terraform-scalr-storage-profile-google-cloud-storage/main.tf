provider "google" {
  project = var.google_project
}

resource "google_storage_bucket" "storage-profile-bucket" {
  name          = var.bucket_name
  location      = var.google_region
  force_destroy = var.force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  labels = {
    name        = "tofu-state-bucket"
    environment = "dev"
  }
}

# Create a service account for Scalr to use
resource "google_service_account" "scalr_service_account" {
  account_id   = "scalr-storage-profile"
  display_name = "Scalr Storage Profile Service Account"
  description  = "Service account for Scalr to access the storage bucket"
}

# Grant the service account access to the bucket
resource "google_storage_bucket_iam_binding" "bucket_admin" {
  bucket = google_storage_bucket.storage-profile-bucket.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.scalr_service_account.email}",
  ]
}

# Create a key for the service account
resource "google_service_account_key" "scalr_service_account_key" {
  service_account_id = google_service_account.scalr_service_account.name
}
