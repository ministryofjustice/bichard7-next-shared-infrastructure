module "deployment_reminder" {
  source            = "../modules/codebuild_job"
  name              = "deployment-reminder"
  build_description = "Daily check to see if deployment is overdue"
  repository_name   = "bichard7-next-shared-infrastructure"
  buildspec_file    = "deployment_reminder.yml"

  event_type_ids = []

  environment_variables = [
    {
      name  = "LIMIT_DAYS"
      value = var.deployment_reminder_limit
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  tags = module.label.tags

}

module "deployment_reminder_trigger" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.deployment_reminder.pipeline_arn
  cron_expression = "cron(0 9 ? * MON-FRI *)"
  name            = module.deployment_reminder.pipeline_name

  tags = module.label.tags
}
