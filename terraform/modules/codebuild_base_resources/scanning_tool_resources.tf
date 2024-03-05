#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "scanning_results_bucket" {
  bucket = "${var.name}-scanning-results"
  acl    = "private"

  force_destroy = true

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
    target_bucket = var.aws_logs_bucket
    target_prefix = "scanning-results/"
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "scanning_results_bucket" {
  bucket = aws_s3_bucket.scanning_results_bucket.bucket

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access_to_scanning_results_bucket" {
  bucket = aws_s3_bucket.scanning_results_bucket.bucket
  policy = templatefile("${path.module}/policies/allow_access_to_scanning_results_bucket.json.tpl", {
    scanning_bucket_arn  = aws_s3_bucket.scanning_results_bucket.arn
    allowed_account_arns = jsonencode(sort(formatlist("arn:aws:iam::%s:root", var.allow_accounts)))
    account_id           = data.aws_caller_identity.current.account_id
    ci_user_arn          = data.aws_iam_user.ci_user.arn
  })
}
