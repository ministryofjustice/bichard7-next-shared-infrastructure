resource "aws_iam_role" "assume_administrator_access" {
  name                 = "Bichard7-Administrator-Access"
  max_session_duration = 10800
  assume_role_policy   = data.template_file.allow_assume_administrator_access_template.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "administrator_access_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.assume_administrator_access.name
}

resource "aws_iam_role" "assume_readonly_access" {
  name                 = "Bichard7-ReadOnly-Access"
  max_session_duration = 10800
  assume_role_policy   = data.template_file.allow_assume_readonly_access_template.rendered

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
  version           = "~> 10.3.0 "
  s3_bucket_name    = "account-logging-${data.aws_caller_identity.current.account_id}-logs"
  force_destroy     = false
  enable_versioning = true

  tags = var.tags
}

resource "aws_s3_bucket" "account_logging_bucket" {
  bucket        = "account-logging-${data.aws_caller_identity.current.account_id}"
  acl           = "log-delivery-write"
  force_destroy = false

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = module.aws_logs.aws_logs_bucket
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "account_logging_bucket" {
  bucket = aws_s3_bucket.account_logging_bucket.bucket
  policy = data.template_file.deny_non_tls_s3_comms_on_logging_bucket.rendered
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
