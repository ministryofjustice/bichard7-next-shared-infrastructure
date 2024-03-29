module "build_reporting" {
  source                 = "../codebuild_job"
  build_description      = "Codebuild Pipeline for building and deploying the artifacts from the Reporting"
  name                   = "build-reporting-artifacts"
  repository_name        = "bichard7-next-reporting"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  allowed_resource_arns = [
    data.aws_ecr_repository.nodejs_20_2023.arn
  ]

  environment_variables = concat(
    [
      {
        name  = "ACCOUNT_ID"
        value = data.aws_caller_identity.current.account_id
      }
    ],
    var.reporting_cd_env_vars
  )

  build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_SMALL"
      image                       = "${data.aws_ecr_repository.nodejs_20_2023.repository_url}@${data.external.latest_nodejs_20_2023_image.result.tags}"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image_pull_credentials_type = "SERVICE_ROLE"
    }
  ]

  tags = var.tags
}

module "build_reporting_trigger" {
  source = "../codebuild_webhook"

  codebuild_project_name = module.build_reporting.pipeline_name
}

module "build_reporting_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_reporting.pipeline_arn
  name            = module.build_reporting.pipeline_name
  cron_expression = "cron(0 6 ? * SUN *)"

  tags = var.tags
}
