resource "aws_iam_policy" "allow_assume_ci_admin_access_role" {
  name   = "Assume-CI-Admin-Access-on-${var.child_account_id}"
  policy = templatefile(
    "${path.module}/policies/allow_assume_ci_admin_access.json.tpl",
    {
      ci_admin_access_arn = var.ci_admin_access_arn
    }
  )
}

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "ci_admin_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_ci_admin_access_role.arn
  group      = data.aws_iam_group.ci_admin_user_group.group_name
}
