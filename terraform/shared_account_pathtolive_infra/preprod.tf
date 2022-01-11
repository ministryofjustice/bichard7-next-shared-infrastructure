module "preprod_child_access" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access"
  root_account_id = data.aws_caller_identity.current.account_id
  tags            = module.label.tags
  bucket_name     = local.remote_bucket_name

  logging_bucket_name = module.aws_logs.aws_logs_bucket

  providers = {
    aws = aws.preprod
  }
}

module "shared_account_access_preprod" {
  source                     = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access"
  child_account_id           = data.aws_caller_identity.preprod.account_id
  ci_access_group_name       = module.shared_account_user_access.ci_access_group.name
  ci_access_arn              = module.preprod_child_access.ci_access_role.arn
  readonly_access_arn        = module.preprod_child_access.readonly_access_role.arn
  readonly_access_group_name = module.shared_account_user_access.readonly_access_group.name
  admin_access_arn           = module.preprod_child_access.administrator_access_role.arn
  admin_access_group_name    = module.shared_account_user_access.administrator_access_group.name

  providers = {
    aws = aws.shared
  }
}

module "shared_account_preprod_lambda_cloudtrail" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail"

  name           = "q-solution"
  logging_bucket = module.aws_logs.aws_logs_bucket

  tags = module.label.tags

  providers = {
    aws = aws.preprod
  }
}