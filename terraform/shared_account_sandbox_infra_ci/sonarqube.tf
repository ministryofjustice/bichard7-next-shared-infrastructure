module "apply_sonarqube" {
  source            = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  name              = "apply-sandbox-ci-sonarqube"
  build_description = "Codebuild Pipeline To reprovision the SonarQube deployment"
  repository_name   = "bichard7-next-shard-infrastructure"

  report_build_status = true

  buildspec_file = "applyci-sonarqube.yml"

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

  environment_variables  = []
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "apply_sonarqube_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.apply_sonarqube.pipeline_arn
  name            = module.apply_sonarqube.pipeline_name
  cron_expression = "cron(0 0 ? * SUN *)" # run every Sunday at midnight

  tags = module.label.tags
}
