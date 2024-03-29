module "manage_aws_users" {
  source                         = "../codebuild_job"
  build_description              = "Run user management jobs on a schedule"
  codepipeline_s3_bucket         = var.codebuild_s3_bucket
  name                           = "manage-aws-users"
  sns_kms_key_arn                = var.notifications_kms_key_arn
  sns_notification_arn           = var.sns_notifications_arn
  repository_name                = "bichard7-next-shared-infrastructure"
  buildspec_file                 = "manage-users-buildspec.yml"
  aws_access_key_id_ssm_path     = "/ci-admin/user/access_key_id"
  aws_secret_access_key_ssm_path = "/ci-admin/user/secret_access_key"

  environment_variables = [
    {
      name  = "WORKSPACE"
      value = var.environment
    }
  ]

  tags = var.tags
}

module "manage_aws_users_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.manage_aws_users.pipeline_arn
  name            = module.manage_aws_users.pipeline_name
  cron_expression = "cron(0 1 * * ? *)"
  tags            = var.tags
}
