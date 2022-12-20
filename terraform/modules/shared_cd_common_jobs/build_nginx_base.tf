module "build_nginx_java_supervisord_docker_image" {
  source = "../codebuild_job"

  name              = "build-nginx-java-supervisord-docker"
  build_description = "Codebuild for Building Nginx and Supervisord On OpenJDK 11"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Nginx_Java_Supervisord/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block
  environment_variables  = var.common_cd_vars

  tags = var.tags
}

module "build_nginx_java_supervisord_docker_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_nginx_java_supervisord_docker_image.pipeline_arn
  name            = module.build_nginx_java_supervisord_docker_image.pipeline_name
  cron_expression = "cron(0 4 ? * SUN *)"

  tags = var.tags
}

module "build_nginx_nodejs_supervisord_docker_image" {
  source = "../codebuild_job"

  name              = "build-nginx-nodejs-supervisord-docker"
  build_description = "Codebuild for Building Nginx and Supervisord On NodeJS 16 Base"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Nginx_NodeJS_Supervisord/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block
  environment_variables  = var.common_cd_vars
  tags                   = var.tags
}

module "build_nginx_nodejs_supervisord_docker_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_nginx_nodejs_supervisord_docker_image.pipeline_arn
  name            = module.build_nginx_nodejs_supervisord_docker_image.pipeline_name
  cron_expression = "cron(0 4 ? * SUN *)"

  tags = var.tags
}

module "build_nginx_supervisord_docker_image" {
  source = "../codebuild_job"

  name                  = "build-nginx-supervisord-docker"
  build_description     = "Codebuild for Building Nginx and Supervisord On Amazon Linux 2 Base"
  repository_name       = "bichard7-next-infrastructure-docker-images"
  buildspec_file        = "./Nginx_Supervisord/buildspec.yml"
  environment_variables = var.common_cd_vars

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  tags = var.tags
}

module "build_nginx_supervisord_docker_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_nginx_supervisord_docker_image.pipeline_arn
  name            = module.build_nginx_supervisord_docker_image.pipeline_name
  cron_expression = "cron(0 4 ? * SUN *)"

  tags = var.tags
}
