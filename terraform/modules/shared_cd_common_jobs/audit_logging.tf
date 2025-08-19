module "build_audit_logging" {
  source                 = "../codebuild_job"
  build_description      = "Codebuild Pipeline for building and deploying the artifacts from the Audit Logging repository"
  name                   = "build-audit-logging-artifacts"
  repository_name        = "bichard7-next-audit-logging"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

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
    var.audit_logging_cd_env_vars
  )

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_MEDIUM"
      image           = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  tags = var.tags
}

module "build_audit_logging_trigger" {
  source = "../codebuild_webhook"

  codebuild_project_name = module.build_audit_logging.pipeline_name
}

module "build_audit_logging_image_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.build_audit_logging.pipeline_arn
  name            = module.build_audit_logging.pipeline_name
  cron_expression = "cron(0 6 ? * SUN *)"
  tags            = var.tags
}
