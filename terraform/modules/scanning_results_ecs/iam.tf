# tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "scanning_bucket_user" {
  name = "scanning.results.reader"
  path = "/system/"
  tags = var.tags
}

resource "random_password" "scanning_portal_password" {
  length  = 24
  special = false
}

resource "aws_iam_access_key" "scanning_bucket_user" {
  user = aws_iam_user.scanning_bucket_user.name
}

resource "aws_ssm_parameter" "scanning_bucket_access_key" {
  name  = "/system/scanning/key"
  type  = "SecureString"
  value = aws_iam_access_key.scanning_bucket_user.id

  tags = var.tags
}

resource "aws_ssm_parameter" "scanning_bucket_secret_key" {
  name  = "/system/scanning/secret"
  type  = "SecureString"
  value = aws_iam_access_key.scanning_bucket_user.secret

  tags = var.tags
}

resource "aws_ssm_parameter" "scanning_portal_username" {
  name  = "/system/scanning/username"
  type  = "SecureString"
  value = "bichard"

  tags = var.tags
}

resource "aws_ssm_parameter" "scanning_portal_password" {
  name  = "/system/scanning/password"
  type  = "SecureString"
  value = random_password.scanning_portal_password.result

  tags = var.tags
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_user_policy" "scanning_user_policy" {
  name = "AllowScanningBucketAccess"
  user = aws_iam_user.scanning_bucket_user.name
  policy = templatefile("${path.module}/policies/scanning_user_policy.json.tpl", {
    scanning_bucket_name = var.scanning_bucket_name
  })
}

resource "aws_kms_key" "cloudwatch_encryption" {
  description = "${var.name}-cloudwatch-encryption"

  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = templatefile("${path.module}/policies/cloudwatch_encryption.json.tpl", {
    account_id               = data.aws_caller_identity.current.account_id
    region                   = data.aws_region.current.name
    scanning_bucket_user_arn = aws_iam_user.scanning_bucket_user.arn
  })

  tags = var.tags
}

resource "aws_kms_alias" "cloudwatch_kms_alias" {
  target_key_id = aws_kms_key.cloudwatch_encryption.arn
  name          = "alias/${aws_kms_key.cloudwatch_encryption.description}"
}
