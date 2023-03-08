resource "aws_iam_user" "ci_admin" {
  name = "ci-admin"
  path = "/system/"

  tags = merge(
    var.tags,
    {
      "user-role" = "ci-admin"
    }
  )
}

# tfsec:ignore:aws-iam-enforce-group-mfa
resource "aws_iam_group" "aws_ci_admin_group" {
  name = "CiAdmin"
}

resource "aws_iam_user_group_membership" "ci_admin" {

  groups = [
    aws_iam_group.aws_ci_admin_group.name
  ]
  user = aws_iam_user.ci_admin.name
}

resource "aws_iam_group_policy_attachment" "admin_user_allow_all_policy" {
  group      = aws_iam_group.aws_ci_admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "ci_admin_user_key" {
  user = aws_iam_user.ci_admin.name
}

resource "aws_ssm_parameter" "ci_admin_user_access_key_id" {
  name  = "/ci-admin/user/access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.ci_admin_user_key.id

  tags = var.tags
}

resource "aws_ssm_parameter" "ci_admin_user_secret_access_key" {
  name  = "/ci-admin/user/secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.ci_admin_user_key.secret

  tags = var.tags
}