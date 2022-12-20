# tfsec:ignore:aws-iam-enforce-mfa
resource "aws_iam_group" "administrator_access_group" {
  name = "AdminAccess"
}

# tfsec:ignore:aws-iam-enforce-mfa
resource "aws_iam_group" "readonly_access_group" {
  name = "ReadOnlyAccess"
}

# tfsec:ignore:aws-iam-enforce-mfa
resource "aws_iam_group" "ci_access_group" {
  name = "CIAccess"
}

# tfsec:ignore:aws-iam-enforce-mfa
resource "aws_iam_group" "mfa_group" {
  name = "EnforceMFA"
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "mfa_policy" {
  name   = "EnforceMFAOnUsers"
  policy = file("${path.module}/policies/enforce_mfa.json")

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "force_mfa" {
  group      = aws_iam_group.mfa_group.name
  policy_arn = aws_iam_policy.mfa_policy.arn
}

resource "aws_iam_group_policy_attachment" "admin_user_allow_all_policy" {
  group      = aws_iam_group.administrator_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "readonly_user_policy" {
  group      = aws_iam_group.readonly_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "ci_policy" {
  name   = "CIAccessPolicy"
  policy = data.template_file.parent_account_ci_policy.rendered

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "ci_group_policy" {
  group      = aws_iam_group.ci_access_group.name
  policy_arn = aws_iam_policy.ci_policy.arn
}

## Allow our admin user to assume our admin role on this account so we can use aws-vault to login
resource "aws_iam_role" "assume_administrator_access_on_parent" {
  name                 = "Bichard7-Administrator-Access"
  max_session_duration = 10800
  assume_role_policy   = data.template_file.allow_assume_administrator_access_template.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "administrator_access_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.assume_administrator_access_on_parent.name
}
