output "aws_s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.storage-profile-bucket.bucket
}

output "aws_s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.storage-profile-bucket.arn
}

output "aws_iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.tofu_backend_access.arn
}

output "aws_s3_audience" {
  description = "The OIDC audience value for AWS S3"
  value       = var.oidc_audience_value
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
            "backend-type": "aws-s3",
            "aws-s3-bucket-name": "${aws_s3_bucket.storage-profile-bucket.bucket}",
            "aws-s3-audience": "${var.oidc_audience_value}",
            "aws-s3-region": "${var.aws_region}",
            "aws-s3-role-arn": "${aws_iam_role.tofu_backend_access.arn}",
            "default": true,
            "name": "${var.storage_profile_name}"
          }
        }
      }'
  EOT
}
