module "build_core" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"
  build_description      = "Codebuild Job for building the artifacts from the Core repository"
  name                   = "build-core-repo-artifacts"
  repository_name        = "bichard7-next-core"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  allowed_resource_arns = [
    data.aws_ecr_repository.nodejs.arn
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
      compute_type                = "BUILD_GENERAL1_MEDIUM"
      image                       = "${data.aws_ecr_repository.nodejs.repository_url}@${data.external.latest_nodejs_image.result.tags}"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image_pull_credentials_type = "SERVICE_ROLE"
    }
  ]

  tags = var.tags
}

module "build_core_trigger" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_webhook?ref=upgrade-aws-provider"

  codebuild_project_name = module.build_core.pipeline_name
}
