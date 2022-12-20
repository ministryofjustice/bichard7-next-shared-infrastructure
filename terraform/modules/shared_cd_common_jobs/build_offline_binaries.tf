module "pull_offline_binaries" {
  source                 = "../codebuild_job"
  build_description      = "Pull trivy db, trivy binary, aws-nuke, goss binary and dgoss binary then store them in s3, so we avoid hitting github rate limits when we pull from there"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  name                   = "pull-offline-binaries"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/pull-offline-binaries-buildspec.yml"
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  environment_variables = [
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  tags = var.tags
}

module "apply_pull_offline_binaries_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.pull_offline_binaries.pipeline_arn
  name            = module.pull_offline_binaries.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"
  tags            = var.tags
}

module "trivy_scan" {
  source            = "../codebuild_job"
  name              = "trivy-scan-containers"
  build_description = "Weekly Trivy scans on our deployable containers"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/trivy-buildspec.yml"

  event_type_ids = []

  environment_variables = [
    {
      name  = "UPLOAD_BUCKET"
      value = var.scanning_results_bucket
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    },
    {
      name  = "JOB_NAME"
      value = "TRIVY"
    }
  ]


  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags

}

module "trivy_scan_trigger" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.trivy_scan.pipeline_arn
  cron_expression = "cron(0 10 ? * MON *)"
  name            = module.trivy_scan.pipeline_name

  tags = var.tags
}
