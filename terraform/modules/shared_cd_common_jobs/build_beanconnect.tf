module "build_bichard7_beanconnect_docker_image" {
  source                 = "../codebuild_job"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  build_description      = "Codebuild for building Bichard7 BeanConnect images"
  name                   = "build-beanconnect-docker"
  repository_name        = "bichard7-next-beanconnect"
  vpc_config             = var.vpc_config_block

  environment_variables = var.beanconnect_cd_env_vars

  tags = var.tags
}

module "build_bichard7_beanconnect_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_bichard7_beanconnect_docker_image.pipeline_arn
  name            = module.build_bichard7_beanconnect_docker_image.pipeline_name
  cron_expression = "cron(0 5 ? * 1 *)"

  tags = var.tags
}

module "build_bichard7_beanconnect_docker_image_trigger" {
  source                 = "../codebuild_webhook"
  codebuild_project_name = module.build_bichard7_beanconnect_docker_image.pipeline_name
}
