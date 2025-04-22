provider "aws" {
    region = var.aws_region
}

resource "random_string" "names_suffix" {
  count   = var.dynamodb_table_name == null ? 1 : 0
  length  = 6
  special = false
  upper   = false
}

locals {
  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name != null ? var.dynamodb_table_name : "tf-locks-${random_string.names_suffix[0].id}"
}

resource "aws_s3_bucket" "storage-profile-bucket" {
  bucket = local.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name        = "TofuStateBucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "storage_profile_bucket_acl" {
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

resource "aws_dynamodb_table" "bucket_locks" {
  name         = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  dynamic "point_in_time_recovery" {
    for_each = var.enable_dynamodb_pitr ? [1] : []
    content {
      enabled = true
    }
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  tags = {
    Name        = "TofuLockTable"
    Environment = "dev"
  }
}

data "tls_certificate" "scalr_te" {
  url = "https://${var.scalr_hostname}"
}

resource "aws_iam_openid_connect_provider" "scalr_te" {
  url             = data.tls_certificate.scalr_te.url
  client_id_list  = [var.oidc_audience_value]
  thumbprint_list = [data.tls_certificate.scalr_te.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "assume_from_scalr" {
  statement {
    sid     = "AllowScalrOIDCAccess"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.scalr_te.arn]
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

  statement {
    sid    = "DynamoDBAccess"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]
    resources = [aws_dynamodb_table.bucket_locks.arn]
  }
}

resource "aws_iam_role_policy" "tofu_backend_permissions" {
  name   = "TofuBackendPermissions"
  role   = aws_iam_role.tofu_backend_access.id
  policy = data.aws_iam_policy_document.tofu_backend_permissions.json
}
