resource "aws_iam_role" "assume_administrator_access" {
  name                 = "Bichard7-Administrator-Access"
  max_session_duration = 10800
  assume_role_policy = templatefile("${path.module}/policies/${local.access_template}", {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "operations"
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "administrator_access_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.assume_administrator_access.name
}

resource "aws_iam_role" "assume_readonly_access" {
  name                 = "Bichard7-ReadOnly-Access"
  max_session_duration = 10800
  assume_role_policy = templatefile(
    "${path.module}/policies/${local.access_template}",
    {
      parent_account_id = var.root_account_id
      excluded_arns     = jsonencode(var.denied_user_arns)
      user_role         = "readonly"
    }
  )
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "readonly_access_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.assume_readonly_access.name
}

resource "aws_s3_bucket_public_access_block" "account_logging_bucket" {
  bucket                  = aws_s3_bucket.account_logging_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "aws_logs" {
  source            = "trussworks/logs/aws"
  version           = "16.2.0"
  s3_bucket_name    = "account-logging-${var.account_id}-logs"
  force_destroy     = false
  versioning_status = "Enabled"

  tags = var.tags
}

resource "aws_s3_bucket" "account_logging_bucket" {
  bucket        = "account-logging-${var.account_id}"
  force_destroy = false

  tags = var.tags
}

resource "aws_s3_bucket_logging" "account_logging_bucket_logging" {
  bucket        = aws_s3_bucket.account_logging_bucket.id
  target_bucket = module.aws_logs.aws_logs_bucket
  target_prefix = ""
}


resource "aws_s3_bucket_acl" "account_logging_bucket_acl" {
  bucket = aws_s3_bucket.account_logging_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_versioning" "account_logging_bucket_versioning" {
  bucket = aws_s3_bucket.account_logging_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# trivy:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "account_logging_bucket_encryption" {
  bucket = aws_s3_bucket.account_logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



resource "aws_s3_bucket_policy" "account_logging_bucket" {
  bucket = aws_s3_bucket.account_logging_bucket.bucket
  policy = templatefile("${path.module}/policies/non_tls_comms_on_bucket_policy.json.tpl", {
    bucket_arn = aws_s3_bucket.account_logging_bucket.arn
  })
}

resource "aws_iam_role" "portal_host_lambda_role" {
  name = "portal-host-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })

  tags = var.tags
}
