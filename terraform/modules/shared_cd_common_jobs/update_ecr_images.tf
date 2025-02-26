module "update_ecr_images" {
  source                         = "../codebuild_job"
  build_description              = "Update ECR images with the latest from the Docker hub"
  codepipeline_s3_bucket         = var.codebuild_s3_bucket
  name                           = "update-ecr-images"
  sns_kms_key_arn                = var.notifications_kms_key_arn
  sns_notification_arn           = var.sns_notifications_arn
  repository_name                = "bichard7-next-shared-infrastructure"
  buildspec_file                 = "update-ecr-images.yml"
  aws_access_key_id_ssm_path     = "/ci-admin/user/access_key_id"
  aws_secret_access_key_ssm_path = "/ci-admin/user/secret_access_key"

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  ]

  tags = var.tags
}

module "update_ecr_images_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.update_ecr_images.pipeline_arn
  name            = module.update_ecr_images.pipeline_name
  cron_expression = "cron(0 22 * * ? *)"
  tags            = var.tags
}
