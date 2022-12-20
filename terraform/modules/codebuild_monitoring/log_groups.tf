resource "aws_kms_key" "logging_encryption_key" {
  description = "${var.name}-cloudwatch-key"

  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = data.template_file.allow_kms_access.rendered

  tags = var.tags
}

resource "aws_kms_alias" "logging_encryption_key_alias" {
  target_key_id = aws_kms_key.logging_encryption_key.arn
  name          = "alias/${var.name}-cloudwatch-key"
}

resource "aws_cloudwatch_log_group" "codebuild_monitoring" {
  name              = "${var.name}-codebuild-monitoring"
  retention_in_days = 731
  kms_key_id        = aws_kms_key.logging_encryption_key.arn

  tags = var.tags
}
