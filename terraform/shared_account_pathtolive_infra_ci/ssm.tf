resource "aws_ssm_parameter" "dynamodb_backup_bucket" {
  name  = "/ci/dynamodb/production/backup_s3_bucket_name"
  type  = "SecureString"
  value = "_"

  tags = module.label.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "dynamodb_backup_assume_role_arn" {
  name  = "/ci/dynamodb/production/backup_assume_role_arn"
  type  = "SecureString"
  value = "_"

  tags = module.label.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
