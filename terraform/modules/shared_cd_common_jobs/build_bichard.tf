module "build_bichard7_next_docker_image" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  repository_name        = "bichard7-next"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  vpc_config             = var.vpc_config_block
  name                   = "build-bichard7-next"
  build_description      = "Codebuild for building Bichard7 images"
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  environment_variables = var.bichard_cd_env_vars

  tags = var.tags
}

module "build_bichard7_next_docker_image_trigger" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_webhook"
  codebuild_project_name = module.build_bichard7_next_docker_image.pipeline_name
}
