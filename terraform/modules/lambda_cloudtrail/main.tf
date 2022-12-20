resource "aws_kms_key" "lambda_trail_encryption" {
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = data.template_file.lambda_cloudtrail_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "lambda_trail_encryption" {
  target_key_id = aws_kms_key.lambda_trail_encryption.id
  name          = "alias/${var.name}-lambda-cloudtrail"
}

# tfsec:ignore:aws-cloudtrail-ensure-cloudwatch-integration
resource "aws_cloudtrail" "lambda_trail" {
  name                          = "${var.name}-lambdas"
  s3_bucket_name                = aws_s3_bucket.lambda_logs_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  enable_log_file_validation    = true
  is_multi_region_trail         = false # tfsec:ignore:AWS063

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  kms_key_id = aws_kms_key.lambda_trail_encryption.arn

  tags = var.tags
}

# tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-encryption-customer-key tfsec:ignore:aws-cloudtrail-require-bucket-access-logging
resource "aws_s3_bucket" "lambda_logs_bucket" {
  bucket        = "${var.name}-lambdas-cloudtrail"
  force_destroy = true

  policy = data.template_file.lambda_logging_bucket.rendered

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

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "lambda_logs_bucket" {
  bucket                  = aws_s3_bucket.lambda_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
