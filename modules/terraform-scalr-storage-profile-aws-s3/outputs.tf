output "aws_s3_bucket_name" {
    description = "The name of the S3 bucket"
    value       = aws_s3_bucket.storage-profile-bucket.bucket
}

output "aws_s3_bucket_arn" {
    description = "The ARN of the S3 bucket"
    value       = aws_s3_bucket.storage-profile-bucket.arn
}

output "aws_s3_audience" {
    description = "The OIDC audience value for AWS S3"
    value       = var.oidc_audience_value
}

output "curl_command" {
  description = "Curl command to create a storage profile in Scalr"
  value       = <<-EOT
    curl -X POST "https://${var.scalr_account_name}.${var.scalr_hostname}/api/iacp/v3/storage-profiles" \
      -H "Authorization: Bearer ${var.scalr_token}" \
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
