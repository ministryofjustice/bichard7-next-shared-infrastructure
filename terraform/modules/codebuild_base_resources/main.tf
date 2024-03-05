#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "codebuild_artifact_bucket" {
  bucket = "${var.name}-codebuild"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "codebuild_artifact_bucket_acl" {
  bucket = aws_s3_bucket.codebuild_artifact_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_logging" "codebuild_artifact_bucket_logging" {
  bucket        = aws_s3_bucket.codebuild_artifact_bucket.id
  target_bucket = var.aws_logs_bucket
  target_prefix = "codebuild/"
}

resource "aws_s3_bucket_versioning" "codebuild_artifact_bucket_versioning" {
  bucket = aws_s3_bucket.codebuild_artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# trivy:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild_artifact_bucket_encryption" {
  bucket = aws_s3_bucket.codebuild_artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifact_bucket_lifecycle_audit_logging" {
  bucket = aws_s3_bucket.codebuild_artifact_bucket.bucket

  rule {
    id = "audit_log_clean_up"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "audit_logging/"
        tags = {
          rule      = "audit_log_clean_up"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "codebuild_artifact_bucket" {
  bucket = aws_s3_bucket.codebuild_artifact_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  child_accounts = compact([for x in var.allow_accounts : x == data.aws_caller_identity.current.account_id ? "" : x])
  cidr_block     = ((var.vpc_cidr_block == null) ? "10.0.0.0/16" : var.vpc_cidr_block)

  allowed_principals = sort(
    concat(
      formatlist("arn:aws:iam::%s:root", var.allow_accounts),
      formatlist("arn:aws:iam::%s:role/Bichard7-CI-Access", local.child_accounts),
      var.is_sandbox_account ? [] : formatlist("arn:aws:iam::%s:role/update-environment-ssm-params-service-role", data.aws_caller_identity.current.account_id)
    )
  )

  allowed_principals_with_lambda = sort(
    concat(
      formatlist("arn:aws:iam::%s:role/portal-host-lambda-role", local.child_accounts),
      formatlist("arn:aws:iam::%s:role/Bichard7-CI-Access", local.child_accounts)
    )
  )
}

resource "aws_s3_bucket_policy" "allow_access_to_codebuild_bucket" {
  bucket = aws_s3_bucket.codebuild_artifact_bucket.bucket

  policy = templatefile("${path.module}/policies/codebuild_bucket_policy.json.tpl", {
    bucket_arn                     = aws_s3_bucket.codebuild_artifact_bucket.arn
    account_id                     = data.aws_caller_identity.current.account_id
    allowed_principals             = jsonencode(local.allowed_principals)
    allowed_principals_with_lambda = jsonencode(local.allowed_principals_with_lambda)
    ci_user_arn                    = data.aws_iam_user.ci_user.arn
  })
}

resource "aws_kms_key" "codebuild_lock_table" {
  description             = "${var.name}-codebuild-lock-table"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "remote_state_key_alias" {
  target_key_id = aws_kms_key.codebuild_lock_table.id
  name          = "alias/${var.name}-codebuild-lock"
}

resource "aws_dynamodb_table" "codebuild_lock_table" {
  hash_key       = "project_name"
  name           = "${var.name}-codebuild-concurrency"
  read_capacity  = 20
  write_capacity = 20

  point_in_time_recovery {
    enabled = true
  }


  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.codebuild_lock_table.arn
  }

  attribute {
    name = "project_name"
    type = "S"
  }

  attribute {
    name = "expire_at"
    type = "N"
  }

  attribute {
    name = "lock_token"
    type = "S"
  }

  global_secondary_index {
    name               = "ExpireAtIndex"
    hash_key           = "expire_at"
    range_key          = "lock_token"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["project_name"]
  }

  tags = var.tags
}

resource "aws_iam_user_policy" "allow_lock_table_access" {
  name = "AllowCIConcurrency"
  user = data.aws_iam_user.ci_user.user_name

  policy = templatefile("${path.module}/policies/allow_dynamodb_lock_table_access.json.tpl", {
    lock_table_arn = aws_dynamodb_table.codebuild_lock_table.arn
  })
}
