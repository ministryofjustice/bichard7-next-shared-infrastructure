resource "aws_iam_policy" "allow_assume_administrator_access_role" {
  name = "Assume-Administrator-Access-on-${var.child_account_id}"
  policy = templatefile(
    "${path.module}/policies/allow_assume_admin_access.json.tpl",
    {
      admin_access_arn = var.admin_access_arn
    }
  )
  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "administrator_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_administrator_access_role.arn
  group      = var.admin_access_group_name
}

resource "aws_iam_policy" "allow_assume_readonly_access_role" {
  name = "Assume-ReadOnly-Access-on-${var.child_account_id}"
  policy = templatefile(
    "${path.module}/policies/allow_assume_readonly_access.json.tpl",
    {
      readonly_access_arn = var.readonly_access_arn
    }
  )

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "readonly_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_readonly_access_role.arn
  group      = var.readonly_access_group_name
}

resource "aws_iam_policy" "allow_assume_aws_support_role" {
  name = "Assume-Aws-Support-Access-on-${var.child_account_id}"
  policy = templatefile(
    "${path.module}/policies/allow_assume_aws_support_access.json.tpl",
    {
      aws_support_access_arn = var.aws_support_access_arn
    }
  )

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "aws_support_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_aws_support_role.arn
  group      = var.aws_support_access_arn
}

resource "aws_iam_policy" "allow_assume_ci_access_role" {
  name = "Assume-CI-Access-on-${var.child_account_id}"
  policy = templatefile(
    "${path.module}/policies/allow_assume_ci_access.json.tpl",
    {
      ci_access_arn = var.ci_access_arn
    }
  )

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "ci_access_policy_attachment" {
  policy_arn = aws_iam_policy.allow_assume_ci_access_role.arn
  group      = var.ci_access_group_name
}
