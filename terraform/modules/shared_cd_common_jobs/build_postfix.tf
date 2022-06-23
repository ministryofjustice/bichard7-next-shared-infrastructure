module "build_postfix_docker_image" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  name              = "build-postfix-docker"
  build_description = "Codebuild for Building Postfix Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Postfix/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  environment_variables = var.common_cd_vars

  tags = var.tags
}
