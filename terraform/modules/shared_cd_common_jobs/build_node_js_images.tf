module "build_nodejs_docker_image" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name                  = "build-nodejs-16-docker"
  build_description     = "Codebuild for Building NodeJS v16 Image"
  repository_name       = "bichard7-next-infrastructure-docker-images"
  buildspec_file        = "./NodeJS/buildspec.yml"
  environment_variables = var.common_cd_vars

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  tags = var.tags
}
