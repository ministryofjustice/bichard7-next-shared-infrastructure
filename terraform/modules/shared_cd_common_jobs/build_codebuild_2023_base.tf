module "build_codebuild_2023_base_docker_image" {
  source = "../codebuild_job"

  name              = "build-codebuild-2023-base"
  build_description = "Codebuild for Building CodeBuild 2023 Base Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Codebuild_2023_Base/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  environment_variables = var.common_cd_vars

  tags = var.tags
}

module "build_codebuild_2023_base_docker_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_codebuild_2023_base_docker_image.pipeline_arn
  name            = module.build_codebuild_2023_base_docker_image.pipeline_name
  cron_expression = "cron(0 4 ? * SUN *)"
  tags            = var.tags
}

module "build_codebuild_2023_base_docker_image_trigger" {
  source                 = "../codebuild_webhook"
  codebuild_project_name = module.build_codebuild_2023_base_docker_image.pipeline_name
}
