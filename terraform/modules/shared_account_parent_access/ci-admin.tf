resource "aws_iam_policy" "allow_assume_ci_admin_access_role" {
  name   = "Assume-CI-Admin-Access-on-${var.child_account_id}"
  policy = data.template_file.allow_assume_ci_admin_access.rendered

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "ci_admin_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_aws_nuke_access_role[count.index].arn
  group      = data.aws_iam_group.ci_admin_user_group.group_name
}
