module "apply_codebuild_layer" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  build_description      = "Apply the shared account ci layer on a schedule"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  name                   = "apply-codebuild-layer"
  sns_kms_key_arn        = var.notifications_kms_key_arn
  sns_notification_arn   = var.sns_notifications_arn
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "applyci-buildspec.yml"

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  ]

  tags = var.tags
}

module "apply_codebuild_layer_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.apply_codebuild_layer.pipeline_arn
  name            = module.apply_codebuild_layer.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"
  tags            = var.tags
}
