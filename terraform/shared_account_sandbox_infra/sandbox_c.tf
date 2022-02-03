module "sandbox_c_child_access" {
  source              = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access"
  root_account_id     = data.aws_caller_identity.current.account_id
  bucket_name         = local.remote_bucket_name
  logging_bucket_name = module.aws_logs.aws_logs_bucket
  create_nuke_user    = true

  tags = module.label.tags

  providers = {
    aws = aws.sandbox_c
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
  aws_nuke_access_arn        = (length(module.sandbox_c_child_access.aws_nuke_access_role) > 0) ? module.sandbox_c_child_access.aws_nuke_access_role[0].arn : null

  providers = {
    aws = aws.sandbox_shared
  }

  depends_on = [
    module.sandbox_c_child_access
  ]

  tags = module.label.tags
}
