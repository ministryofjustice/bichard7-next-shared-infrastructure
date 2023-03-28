module "build_bichard7_api_docker_image" {
  source                 = "../codebuild_job"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block
  build_description      = "Codebuild for building B7 API"
  name                   = "build-api-docker"
  repository_name        = "bichard7-next-core"
  buildspec_file         = "./api/buildspec.yml"

  environment_variables = var.api_cd_env_vars

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

module "build_bichard7_api_docker_image_trigger" {
  source                 = "../codebuild_webhook"
  codebuild_project_name = module.build_bichard7_api_docker_image.pipeline_name
  file_path              = "api/"
}

module "build_bichard7_api_docker_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_bichard7_api_docker_image.pipeline_arn
  name            = module.build_bichard7_api_docker_image.pipeline_name
  cron_expression = "cron(0 6 ? * SUN *)"

  tags = var.tags
}