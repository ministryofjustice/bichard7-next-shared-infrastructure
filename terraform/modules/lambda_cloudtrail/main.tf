resource "aws_kms_key" "lambda_trail_encryption" {
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = templatefile("${path.module}/policies/lambda_cloudtrail.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })

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
  bucket = "${var.name}-lambdas-cloudtrail"



  tags = var.tags
}

resource "aws_s3_bucket_policy" "lambda_logs_bucket_policy" {
  bucket = aws_s3_bucket.lambda_logs_bucket.id
  policy = templatefile("${path.module}/policies/lambda_logging_bucket.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
    name       = var.name
  })
}

resource "aws_s3_bucket_versioning" "lambda_logs_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# trivy:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_logs_bucket_encryption" {
  bucket = aws_s3_bucket.lambda_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_logs_bucket" {
  bucket                  = aws_s3_bucket.lambda_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
