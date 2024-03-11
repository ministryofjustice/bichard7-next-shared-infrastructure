resource "aws_iam_role" "assume_ci_admin_access" {
  name                 = "Bichard7-CI-Admin-Access"
  max_session_duration = 10800
  assume_role_policy = templatefile("${path.module}/policies/${local.no_mfa_access_template}", {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "ci-admin"
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "allow_ci_admin" {
  name   = "CiAdminPolicy"
  role   = aws_iam_role.assume_ci_admin_access.id
  policy = file("${path.module}/policies/allow_ci_admin.json")
}
