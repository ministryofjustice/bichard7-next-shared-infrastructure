module "build_core" {
  source                 = "../codebuild_job"
  build_description      = "Codebuild Job for building the artifacts from the Core repository"
  name                   = "build-core-repo-artifacts"
  repository_name        = "bichard7-next-core"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  environment_variables = var.core_cd_env_vars

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_LARGE"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  tags = var.tags
}

module "build_core_trigger" {
  source = "../codebuild_webhook"

  codebuild_project_name = module.build_core.pipeline_name
}

module "build_core_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_core.pipeline_arn
  name            = module.build_core.pipeline_name
  cron_expression = "cron(0 6 ? * SUN *)"
  tags            = var.tags
}
