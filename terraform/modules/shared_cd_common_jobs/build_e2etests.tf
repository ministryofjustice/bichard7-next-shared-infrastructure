module "build_bichard7_e2etests_docker_image" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block
  build_description      = "Codebuild for Building the End-to-End Tests"
  name                   = "build-e2etests-docker"
  repository_name        = "bichard7-next-tests"
  environment_variables  = var.common_cd_vars
  tags                   = var.tags
}

module "build_bichard7_e2etests_docker_image_trigger" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_webhook?ref=upgrade-aws-provider"
  codebuild_project_name = module.build_bichard7_e2etests_docker_image.pipeline_name
}

module "build_bichard7_e2etests_docker_image_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule?ref=upgrade-aws-provider"
  codebuild_arn   = module.build_bichard7_e2etests_docker_image.pipeline_arn
  name            = module.build_bichard7_e2etests_docker_image.pipeline_name
  cron_expression = "cron(0 5 ? * 1 *)"

  tags = var.tags
}
