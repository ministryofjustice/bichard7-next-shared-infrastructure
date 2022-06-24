module "build_bichard7_pncemulator_docker_image" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  name                   = "build-pnc-emulator-docker"
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  build_description      = "Codebuild for Building Bichard7 PNC Emulator images"
  vpc_config             = var.vpc_config_block
  repository_name        = "bichard7-next-pnc-emulator"

  environment_variables = [
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  tags = var.tags
}

module "build_bichard7_pncemulator_docker_image_trigger" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_webhook"
  codebuild_project_name = module.build_bichard7_pncemulator_docker_image.pipeline_name
}

module "build_bichard7_pncemulator_docker_image_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_bichard7_pncemulator_docker_image.pipeline_arn
  name            = module.build_bichard7_pncemulator_docker_image.pipeline_name
  cron_expression = "cron(0 6 ? * 2 *)"
  tags            = var.tags
}
