module "production_child_access" {
  source              = "../modules/shared_account_child_access"
  root_account_id     = data.aws_caller_identity.current.account_id
  tags                = module.label.tags
  bucket_name         = local.remote_bucket_name
  denied_user_arns    = split(",", data.aws_ssm_parameter.non_sc_users.value)
  logging_bucket_name = module.aws_logs.aws_logs_bucket

  providers = {
    aws = aws.production
  }

  depends_on = [
    module.shared_account_user_access
  ]
}

module "shared_account_access_production" {
  source                     = "../modules/shared_account_parent_access"
  child_account_id           = data.aws_caller_identity.production.account_id
  ci_access_group_name       = module.shared_account_user_access.ci_access_group.name
  ci_access_arn              = module.production_child_access.ci_access_role.arn
  ci_admin_access_arn        = module.production_child_access.ci_admin_access_role.arn
  readonly_access_arn        = module.production_child_access.readonly_access_role.arn
  readonly_access_group_name = module.shared_account_user_access.readonly_access_group.name
  admin_access_arn           = module.production_child_access.administrator_access_role.arn
  admin_access_group_name    = module.shared_account_user_access.administrator_access_group.name

  providers = {
    aws = aws.shared
  }

  tags = module.label.tags

  depends_on = [
    module.shared_account_user_access
  ]
}

module "shared_account_production_next_lambda_cloudtrail" {
  source = "../modules/lambda_cloudtrail"

  name           = "production"
  logging_bucket = module.aws_logs.aws_logs_bucket

  tags = module.label.tags

  providers = {
    aws = aws.production
  }
}
