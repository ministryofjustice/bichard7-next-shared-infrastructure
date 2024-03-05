resource "aws_iam_role" "assume_ci_access" {
  name                 = "Bichard7-CI-Access"
  max_session_duration = 10800
  assume_role_policy = templatefile("${path.module}/policies/${local.no_mfa_multi_user_roles_access_template}", {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "ci/cd"
    admin_user_role   = "ci-admin"
  })

  tags = var.tags
}

resource "aws_iam_policy" "ci_to_parent_policy" {
  name = "CIAccessToParent"
  policy = file("${path.module}/policies/child_to_parent_policy.json.tpl", {
    parent_account_id = var.root_account_id
    bucket_name       = var.bucket_name
    logging_bucket    = var.logging_bucket_name
  })

  tags = var.tags
}

resource "aws_iam_policy" "ci_permissions_policy_part1" {
  name = "CIPolicyPart1"
  policy = templatefile("${path.module}/policies/child_ci_policy_part1.json.tpl", {
    parent_account_id = var.root_account_id
    account_id        = var.account_id
    bucket_name       = var.bucket_name
    region            = data.aws_region.current_region.name
  })

  tags = var.tags
}

resource "aws_iam_policy" "ci_permissions_policy_part2" {
  name = "CIPolicyPart2"
  policy = templatefile("${path.module}/policies/child_ci_policy_part2.json.tpl", {
    parent_account_id = var.root_account_id
    account_id        = var.account_id
    bucket_name       = var.bucket_name
    region            = data.aws_region.current_region.name
  })

  tags = var.tags
}

resource "aws_iam_policy" "deny_ci_permissions_policy" {
  name = "DenyCIActions"
  policy = templatefile("${path.module}/policies/deny_attach_policy_to_ci.json.tpl", {
    account_id = var.account_id
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "deny_ci_permissions_policy_attachment" {
  policy_arn = aws_iam_policy.deny_ci_permissions_policy.arn
  role       = aws_iam_role.assume_ci_access.name
}

resource "aws_iam_role_policy_attachment" "ci_parent_access_policy_attachment" {
  policy_arn = aws_iam_policy.ci_to_parent_policy.arn
  role       = aws_iam_role.assume_ci_access.name
}

resource "aws_iam_role_policy_attachment" "ci_access_policy_attachment_part1" {
  policy_arn = aws_iam_policy.ci_permissions_policy_part1.arn
  role       = aws_iam_role.assume_ci_access.name
}

resource "aws_iam_role_policy_attachment" "ci_access_policy_attachment_part2" {
  policy_arn = aws_iam_policy.ci_permissions_policy_part2.arn
  role       = aws_iam_role.assume_ci_access.name
}

# tfsec:ignore:aws-iam-block-kms-policy-wildcard
# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "ci_policy" {
  name   = "ManagedCIPolicy"
  policy = file("${path.module}/policies/child_ci_policy_part3.json")

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ci_policies" {
  role       = aws_iam_role.assume_ci_access.name
  policy_arn = aws_iam_policy.ci_policy.arn
}

resource "aws_iam_service_linked_role" "es_service_role" {
  aws_service_name = "es.amazonaws.com"

  tags = var.tags
}

# tfsec:ignore:aws-iam-block-kms-policy-wildcard
# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_role_scoutsuite_read" {
  policy = file("${path.module}/policies/allow_scoutsuite.json")
  role   = aws_iam_role.assume_ci_access.id
  name   = "AllowCIScoutSuite"
}
