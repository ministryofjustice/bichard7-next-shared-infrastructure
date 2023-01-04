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

  tags = var.tags
}

module "build_conductor_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_conductor_image.pipeline_arn
  name            = module.build_conductor_image.pipeline_name
  cron_expression = "cron(0 5 ? * SUN *)"

  tags = var.tags
}
