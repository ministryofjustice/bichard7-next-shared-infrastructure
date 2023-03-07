module "apply_access_layer" {
  source                 = "../codebuild_job"
  build_description      = "Apply the shared account infra layer on a schedule"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  name                   = "apply-access-layer"
  sns_kms_key_arn        = var.notifications_kms_key_arn
  sns_notification_arn   = var.sns_notifications_arn
  repository_name        = "bichard7-next-shared-infrastructure"
  buildspec_file         = "applyci-access.yml"

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    },
    {
      name = "AUTO_APPROVE"
      value = true
    }
  ]

  tags = var.tags
}

module "apply_access_layer_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.apply_access_layer.pipeline_arn
  name            = module.apply_access_layer.pipeline_name
  cron_expression = "cron(0 23 * * ? *)"
  tags            = var.tags
}
