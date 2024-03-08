# tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "ci_user" {
  name = data.aws_ssm_parameter.ci_user.value
  path = "/system/"

  tags = merge(
    var.tags,
    {
      "user-role" = "ci/cd"
    }
  )
}

resource "aws_iam_user_group_membership" "ci_user" {
  groups = [
    aws_iam_group.ci_access_group.name
  ]
  user = aws_iam_user.ci_user.name
}

resource "aws_iam_access_key" "ci_user_key" {
  user = aws_iam_user.ci_user.name
}

resource "aws_ssm_parameter" "ci_user_access_key_id" {
  name  = "/ci/user/access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.ci_user_key.id

  tags = var.tags
}

resource "aws_ssm_parameter" "ci_user_secret_access_key" {
  name  = "/ci/user/secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.ci_user_key.secret

  tags = var.tags
}

# tfsec:ignore:aws-iam-block-kms-policy-wildcard
# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_group_policy" "ci_user_allow_scoutsuite" {
  group  = aws_iam_group.ci_access_group.name
  policy = file("${path.module}/policies/allow_scoutsuite.json")
  name   = "AllowCIScoutSuite"
}

resource "aws_iam_user_policy" "allow_ci_codebuild_all" {
  policy = templatefile(
    "${path.module}/policies/allow_codebuild.json.tpl",
    {
      root_account_id = data.aws_caller_identity.current.account_id
    }
  )
  user = aws_iam_user.ci_user.name
}

resource "aws_iam_user_policy" "allow_aws_logs_bucket" {
  name   = "AWSLogsBucketAccess"
  policy = file("${path.module}/policies/allow_aws_logs_bucket.json")
  user   = aws_iam_user.ci_user.name
}

resource "aws_iam_group_policy_attachment" "allow_ci_ssm_read_only" {
  group      = aws_iam_group.ci_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
