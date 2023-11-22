module "apply_codebuild_layer" {
  source                         = "../codebuild_job"
  build_description              = "Apply the shared account ci layer on a schedule"
  codepipeline_s3_bucket         = var.codebuild_s3_bucket
  name                           = "apply-codebuild-layer"
  sns_kms_key_arn                = var.notifications_kms_key_arn
  sns_notification_arn           = var.sns_notifications_arn
  repository_name                = "bichard7-next-shared-infrastructure"
  buildspec_file                 = "applyci-buildspec.yml"
  aws_access_key_id_ssm_path     = "/ci-admin/user/access_key_id"
  aws_secret_access_key_ssm_path = "/ci-admin/user/secret_access_key"

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  ]

  tags = var.tags
}

module "apply_codebuild_layer_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.apply_codebuild_layer.pipeline_arn
  name            = module.apply_codebuild_layer.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"
  tags            = var.tags
}
