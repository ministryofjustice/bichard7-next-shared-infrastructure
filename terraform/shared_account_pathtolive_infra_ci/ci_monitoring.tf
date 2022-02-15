module "build_ci_monitoring" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "apply-ci-monitoring-layer"
  build_description = "Apply our CI Monitoring Layer"
  repository_name   = "bichard7-next-shared-infrastructure"
  buildspec_file    = "applyci-monitoring.yml"

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  environment_variables  = local.common_cd_vars

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn
  ]

  build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_SMALL"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image                       = "${data.aws_ecr_repository.codebuild_base.repository_url}@${data.external.latest_codebuild_base.result.tags}"
      image_pull_credentials_type = "SERVICE_ROLE"

    }
  ]

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "build_ci_monitoring_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_ci_monitoring.pipeline_arn
  name            = module.build_ci_monitoring.pipeline_name
  cron_expression = "cron(1 0 ? * THU *)"

  tags = module.label.tags
}
