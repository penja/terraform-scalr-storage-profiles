provider "aws" {
  region = var.aws_region
}

locals {
  bucket_name         = var.bucket_name
  oidc_provider_arn = data.external.check_oidc.result.exists == "true" ? data.external.check_oidc.result.arn : aws_iam_openid_connect_provider.new[0].arn
}

resource "aws_s3_bucket" "storage-profile-bucket" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "storage_profile_bucket_ownership" {
  bucket = aws_s3_bucket.storage-profile-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "storage_profile_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.storage_profile_bucket_ownership]
  bucket = aws_s3_bucket.storage-profile-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "storage_profile_bucket_versioning" {
  bucket = aws_s3_bucket.storage-profile-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "storage_profile_bucket_encryption" {
  count = var.enable_s3_encryption ? 1 : 0

  bucket = aws_s3_bucket.storage-profile-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


data "tls_certificate" "scalr" {
  url = "https://${var.scalr_hostname}"
}

data "external" "check_oidc" {
  program = ["bash", "${path.module}/check_oidc.sh", var.scalr_hostname]
}

# Create new OIDC provider only if it doesn't exist
resource "aws_iam_openid_connect_provider" "new" {
  count = data.external.check_oidc.result.exists == "true" ? 0 : 1
  url   = "https://${var.scalr_hostname}"

  client_id_list = [
    var.oidc_audience_value
  ]

  thumbprint_list = [data.tls_certificate.scalr.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "assume_from_scalr" {
  statement {
    sid = "AllowScalrOIDCAccess"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [local.oidc_provider_arn]
    }
    condition {
      test     = "StringLike"
      variable = "${var.scalr_hostname}:sub"
      values = [
        format(
          "scalr:account:%s",
          var.scalr_account_name
        )
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.scalr_hostname}:aud"
      values = [
        var.oidc_audience_value
      ]
    }
  }
}

resource "aws_iam_role" "tofu_backend_access" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_from_scalr.json
}

data "aws_iam_policy_document" "tofu_backend_permissions" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      aws_s3_bucket.storage-profile-bucket.arn,
      "${aws_s3_bucket.storage-profile-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "tofu_backend_permissions" {
  name   = "TofuBackendPermissions"
  role   = aws_iam_role.tofu_backend_access.id
  policy = data.aws_iam_policy_document.tofu_backend_permissions.json
}
