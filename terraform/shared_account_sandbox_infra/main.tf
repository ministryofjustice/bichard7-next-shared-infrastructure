module "tag_vars" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "sharedaccount-bootstrap"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = false
    "environment-name" = "sharedaccount-bootstrap"
    "account-name"     = "bichard7-sandbox-shared"
    "provisioned-by"   = "shared_account_sandbox_infra code see make shared-account-sandbox-infra in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-shared-infrastructure/tree/master/shared_terraform/shared_account_sandbox_infra"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.id
  }
}

module "aws_logs" {
  source            = "trussworks/logs/aws"
  version           = "~> 10.3.0 "
  s3_bucket_name    = "${module.label.name}-aws-logs"
  enable_versioning = true

  tags = module.label.tags
}

module "sandbox_a_child_access" {
  source              = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access"
  root_account_id     = data.aws_caller_identity.current.account_id
  tags                = module.label.tags
  bucket_name         = local.remote_bucket_name
  logging_bucket_name = module.aws_logs.aws_logs_bucket

  providers = {
    aws = aws.sandbox_a
  }
}

module "sandbox_b_child_access" {
  source              = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access"
  root_account_id     = data.aws_caller_identity.current.account_id
  tags                = module.label.tags
  bucket_name         = local.remote_bucket_name
  logging_bucket_name = module.aws_logs.aws_logs_bucket

  providers = {
    aws = aws.sandbox_b
  }
}

module "sandbox_c_child_access" {
  source              = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access"
  root_account_id     = data.aws_caller_identity.current.account_id
  tags                = module.label.tags
  bucket_name         = local.remote_bucket_name
  logging_bucket_name = module.aws_logs.aws_logs_bucket

  providers = {
    aws = aws.sandbox_c
  }
}

module "shared_account_user_access" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent"

  buckets = [
    "arn:aws:s3:::${local.remote_bucket_name}",
    "arn:aws:s3:::${module.aws_logs.aws_logs_bucket}"
  ]

  tags = module.label.tags
}

module "shared_account_access_sandbox_a" {
  source                     = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access"
  child_account_id           = data.aws_caller_identity.sandbox_a.account_id
  admin_access_group_name    = module.shared_account_user_access.administrator_access_group.name
  readonly_access_group_name = module.shared_account_user_access.readonly_access_group.name
  ci_access_group_name       = module.shared_account_user_access.ci_access_group.name
  readonly_access_arn        = module.sandbox_a_child_access.readonly_access_role.arn
  admin_access_arn           = module.sandbox_a_child_access.administrator_access_role.arn
  ci_access_arn              = module.sandbox_a_child_access.ci_access_role.arn

  providers = {
    aws = aws.sandbox_shared
  }
}

module "shared_account_access_sandbox_b" {
  source                     = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access"
  child_account_id           = data.aws_caller_identity.sandbox_b.account_id
  admin_access_group_name    = module.shared_account_user_access.administrator_access_group.name
  readonly_access_group_name = module.shared_account_user_access.readonly_access_group.name
  ci_access_group_name       = module.shared_account_user_access.ci_access_group.name
  readonly_access_arn        = module.sandbox_b_child_access.readonly_access_role.arn
  admin_access_arn           = module.sandbox_b_child_access.administrator_access_role.arn
  ci_access_arn              = module.sandbox_b_child_access.ci_access_role.arn

  providers = {
    aws = aws.sandbox_shared
  }
}

module "shared_account_access_sandbox_c" {
  source                     = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access"
  child_account_id           = data.aws_caller_identity.sandbox_c.account_id
  admin_access_group_name    = module.shared_account_user_access.administrator_access_group.name
  readonly_access_group_name = module.shared_account_user_access.readonly_access_group.name
  ci_access_group_name       = module.shared_account_user_access.ci_access_group.name
  readonly_access_arn        = module.sandbox_c_child_access.readonly_access_role.arn
  admin_access_arn           = module.sandbox_c_child_access.administrator_access_role.arn
  ci_access_arn              = module.sandbox_c_child_access.ci_access_role.arn

  providers = {
    aws = aws.sandbox_shared
  }
}
