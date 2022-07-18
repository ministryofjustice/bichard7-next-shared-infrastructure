module "build_bichard7_user_service_docker_image" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block
  build_description      = "Codebuild for building the User Service"
  name                   = "build-user-service-docker"
  repository_name        = "bichard7-next-user-service"

  environment_variables = var.user_service_cd_env_vars

  tags = var.tags
}

module "build_bichard7_user_service_docker_image_trigger" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_webhook"
  codebuild_project_name = module.build_bichard7_user_service_docker_image.pipeline_name
}

module "build_bichard7_user_service_docker_image_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_bichard7_user_service_docker_image.pipeline_arn
  name            = module.build_bichard7_user_service_docker_image.pipeline_name
  cron_expression = "cron(0 6 ? * SUN *)"

  tags = var.tags
}
