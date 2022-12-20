module "build_s3_web_proxy" {
  source = "../codebuild_job"

  name              = "build-s3-web-proxy"
  build_description = "Codebuild for Building the S3 Web Proxy Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./S3_Web_Proxy/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  environment_variables  = var.common_cd_vars

  tags = var.tags
}


module "build_s3_web_proxy_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_s3_web_proxy.pipeline_arn
  name            = module.build_s3_web_proxy.pipeline_name
  cron_expression = "cron(0 4 ? * 2 *)"
  tags            = var.tags
}
