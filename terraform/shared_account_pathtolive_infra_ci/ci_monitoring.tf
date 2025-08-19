module "build_ci_monitoring" {
  source = "../modules/codebuild_job"

  name                           = "apply-ci-monitoring-layer"
  build_description              = "Apply our CI Monitoring Layer"
  repository_name                = "bichard7-next-shared-infrastructure"
  buildspec_file                 = "applyci-monitoring.yml"
  aws_access_key_id_ssm_path     = "/ci-admin/user/access_key_id"
  aws_secret_access_key_ssm_path = "/ci-admin/user/secret_access_key"

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  environment_variables  = local.common_cd_vars

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.codebuild_2023_pipeline_build_environments

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "build_ci_monitoring_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.build_ci_monitoring.pipeline_arn
  name            = module.build_ci_monitoring.pipeline_name
  cron_expression = "cron(1 0 ? * THU *)"

  tags = module.label.tags
}
