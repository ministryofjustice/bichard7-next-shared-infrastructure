module "build_core" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  build_description      = "Codebuild Job for building the artifacts from the Core repository"
  name                   = "build-core-repo-artifacts"
  repository_name        = "bichard7-next-core"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  environment_variables = [
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  tags = var.tags
}

module "build_core_trigger" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_webhook"

  codebuild_project_name = module.build_core.pipeline_name
}
