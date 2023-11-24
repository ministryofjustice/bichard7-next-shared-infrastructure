data "aws_region" "current_region" {}

data "template_file" "ci_to_parent_policy_template" {
  template = file("${path.module}/policies/child_to_parent_policy.json.tpl")
  vars = {
    parent_account_id = var.root_account_id
    bucket_name       = var.bucket_name
    logging_bucket    = var.logging_bucket_name
  }
}

data "template_file" "ci_policy_document_part1" {
  template = file("${path.module}/policies/child_ci_policy_part1.json.tpl")
  vars = {
    parent_account_id = var.root_account_id
    account_id        = var.account_id
    bucket_name       = var.bucket_name
    region            = data.aws_region.current_region.name
  }
}

data "template_file" "ci_policy_document_part2" {
  template = file("${path.module}/policies/child_ci_policy_part2.json.tpl")
  vars = {
    parent_account_id = var.root_account_id
    account_id        = var.account_id
    bucket_name       = var.bucket_name
    region            = data.aws_region.current_region.name
  }
}

data "template_file" "deny_ci_permissions_policy" {
  template = file("${path.module}/policies/deny_attach_policy_to_ci.json.tpl")
  vars = {
    account_id = var.account_id
  }
}

data "template_file" "allow_assume_ci_access_template" {
  template = file("${path.module}/policies/${local.no_mfa_multi_user_roles_access_template}")

  vars = {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "ci/cd"
    admin_user_role   = "ci-admin"
  }
}

data "template_file" "allow_assume_administrator_access_template" {
  template = file("${path.module}/policies/${local.access_template}")

  vars = {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "operations"
  }
}

data "template_file" "allow_assume_readonly_access_template" {
  template = file("${path.module}/policies/${local.access_template}")

  vars = {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "readonly"
  }
}

data "template_file" "deny_non_tls_s3_comms_on_logging_bucket" {
  template = file("${path.module}/policies/non_tls_comms_on_bucket_policy.json.tpl")

  vars = {
    bucket_arn = aws_s3_bucket.account_logging_bucket.arn
  }
}

data "template_file" "allow_assume_aws_nuke_access" {
  count    = (var.create_nuke_user == true) ? 1 : 0
  template = file("${path.module}/policies/${local.no_mfa_access_template}")

  vars = {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "aws-nuke"
  }
}

data "template_file" "allow_assume_ci_admin_access" {
  template = file("${path.module}/policies/${local.no_mfa_access_template}")

  vars = {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "ci-admin"
  }
}
