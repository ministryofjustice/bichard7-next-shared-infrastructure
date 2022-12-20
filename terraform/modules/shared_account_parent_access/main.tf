resource "aws_iam_policy" "allow_assume_administrator_access_role" {
  name   = "Assume-Administrator-Access-on-${var.child_account_id}"
  policy = data.template_file.allow_assume_administrator_access.rendered

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "administrator_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_administrator_access_role.arn
  group      = var.admin_access_group_name
}

resource "aws_iam_policy" "allow_assume_readonly_access_role" {
  name   = "Assume-ReadOnly-Access-on-${var.child_account_id}"
  policy = data.template_file.allow_assume_readonly_access.rendered

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "readonly_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_readonly_access_role.arn
  group      = var.readonly_access_group_name
}

resource "aws_iam_policy" "allow_assume_ci_access_role" {
  name   = "Assume-CI-Access-on-${var.child_account_id}"
  policy = data.template_file.allow_assume_ci_access.rendered

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "ci_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_ci_access_role.arn
  group      = var.ci_access_group_name
}
