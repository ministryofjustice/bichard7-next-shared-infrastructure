resource "aws_kms_key" "terraform_remote_state_key" {
  description             = "${var.name} key"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "remote_state_key_alias" {
  target_key_id = aws_kms_key.terraform_remote_state_key.id
  name          = "alias/${var.name}-remote-state"
}

resource "aws_s3_bucket_public_access_block" "terraform_remote_state" {
  bucket                  = aws_s3_bucket.terraform_remote_state.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "${var.name}-tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_remote_state_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = var.logging_bucket_name
    target_prefix = var.name
  }

  force_destroy = false

  tags = var.tags
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.name}-tfstate-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.terraform_remote_state_key.arn
  }

  tags = var.tags
}
