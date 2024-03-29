module "build_nginx_nodejs_20_2023_supervisord_docker_image" {
  source = "../codebuild_job"

  name                  = "build-nginx-nodejs-20-2023-supervisord-docker"
  build_description     = "Codebuild for Building Nginx and Supervisord On NodeJS 20 Base With amazonlinux:2023"
  repository_name       = "bichard7-next-infrastructure-docker-images"
  buildspec_file        = "./Nginx_NodeJS_20_2023_Supervisord/buildspec.yml"
  environment_variables = var.common_cd_vars

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  tags = var.tags
}

module "build_nginx_nodejs_20_2023_supervisord_docker_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_nginx_nodejs_20_2023_supervisord_docker_image.pipeline_arn
  name            = module.build_nginx_nodejs_20_2023_supervisord_docker_image.pipeline_name
  cron_expression = "cron(0 4 ? * SUN *)"

  tags = var.tags
}
