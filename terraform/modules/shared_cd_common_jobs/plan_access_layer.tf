module "plan_access_layer" {
  source                         = "../codebuild_job"
  build_description              = "Plan the shared account infra layer"
  codepipeline_s3_bucket         = var.codebuild_s3_bucket
  name                           = "plan-access-layer"
  sns_kms_key_arn                = var.notifications_kms_key_arn
  sns_notification_arn           = var.sns_notifications_arn
  repository_name                = "bichard7-next-shared-infrastructure"
  buildspec_file                 = "planci-access.yml"
  aws_access_key_id_ssm_path     = "/ci-admin/user/access_key_id"
  aws_secret_access_key_ssm_path = "/ci-admin/user/secret_access_key"

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    }
  ]

  tags = var.tags
}
