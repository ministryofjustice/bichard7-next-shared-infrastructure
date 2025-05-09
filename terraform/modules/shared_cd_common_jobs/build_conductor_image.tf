module "build_conductor_image" {
  source = "../codebuild_job"

  name              = "build-conductor-image"
  build_description = "Codebuild for Building Conductor Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Conductor/buildspec.yml"

  environment_variables = var.user_service_cd_env_vars

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_MEDIUM"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  tags = var.tags
}

module "build_bichard7_conductor_image_trigger" {
  source                 = "../codebuild_webhook"
  codebuild_project_name = module.build_conductor_image.pipeline_name
}

module "build_conductor_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_conductor_image.pipeline_arn
  name            = module.build_conductor_image.pipeline_name
  cron_expression = "cron(0 5 ? * SUN *)"

  tags = var.tags
}
