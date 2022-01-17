module "integration_baseline_child_access" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access"
  root_account_id = data.aws_caller_identity.current.account_id
  tags            = module.label.tags
  bucket_name     = local.remote_bucket_name

  logging_bucket_name = module.aws_logs.aws_logs_bucket

  providers = {
    aws = aws.integration_baseline
  }
}

# Credentials match bichard7-test-current account
module "shared_account_access_integration_baseline" {
  source                     = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access"
  child_account_id           = data.aws_caller_identity.integration_baseline.account_id
  admin_access_group_name    = module.shared_account_user_access.administrator_access_group.name
  readonly_access_group_name = module.shared_account_user_access.readonly_access_group.name
  ci_access_group_name       = module.shared_account_user_access.ci_access_group.name
  readonly_access_arn        = module.integration_baseline_child_access.readonly_access_role.arn
  admin_access_arn           = module.integration_baseline_child_access.administrator_access_role.arn
  ci_access_arn              = module.integration_baseline_child_access.ci_access_role.arn

  providers = {
    aws = aws.shared
  }

  tags = module.label.tags
}

module "shared_account_access_integration_baseline_lambda_cloudtrail" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail"

  name           = "integration-baseline"
  logging_bucket = module.aws_logs.aws_logs_bucket

  tags = module.label.tags

  providers = {
    aws = aws.integration_baseline
  }
}
