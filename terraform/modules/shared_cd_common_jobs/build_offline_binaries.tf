module "pull_offline_binaries" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"
  build_description      = "Pull trivy db, trivy binary, aws-nuke, goss binary and dgoss binary then store them in s3, so we avoid hitting github rate limits when we pull from there"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  name                   = "pull-offline-binaries"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "pull-offline-binaries-buildspec.yml"
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
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule?ref=upgrade-aws-provider"
  codebuild_arn   = module.pull_offline_binaries.pipeline_arn
  name            = module.pull_offline_binaries.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"
  tags            = var.tags
}

module "trivy_scan" {
  source            = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"
  name              = "trivy-scan-containers"
  build_description = "Weekly Trivy scans on our deployable containers"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "trivy-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

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
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule?ref=upgrade-aws-provider"
  codebuild_arn   = module.trivy_scan.pipeline_arn
  cron_expression = "cron(0 10 ? * MON *)"
  name            = module.trivy_scan.pipeline_name

  tags = var.tags
}
