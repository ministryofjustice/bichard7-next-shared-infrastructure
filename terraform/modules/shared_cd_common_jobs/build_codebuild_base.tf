module "build_codebuild_base_docker_image" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-codebuild-base"
  build_description = "Codebuild for Building CodeBuild Base Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Codebuild_Base/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  environment_variables = var.common_cd_vars

  tags = var.tags
}

module "build_codebuild_base_docker_image_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_codebuild_base_docker_image.pipeline_arn
  name            = module.build_codebuild_base_docker_image.pipeline_name
  cron_expression = "cron(0 4 ? * SUN *)"
  tags            = var.tags
}
