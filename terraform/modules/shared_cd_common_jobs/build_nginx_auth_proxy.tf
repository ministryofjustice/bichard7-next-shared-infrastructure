module "build_nginx_auth_proxy_docker_image" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  name              = "build-nginx-auth-proxy-docker"
  build_description = "Codebuild for Building Nginx Authentication Proxy"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Nginx_Auth_Proxy/buildspec.yml"

  environment_variables = var.user_service_cd_env_vars

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  tags = var.tags
}
