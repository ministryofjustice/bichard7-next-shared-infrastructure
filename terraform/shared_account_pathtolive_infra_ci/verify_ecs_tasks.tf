module "verify_ecs_tasks" {
  source = "../modules/codebuild_job"

  build_description      = "Verifies ECS tasks are healthy and using correct task definitions"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "verify-ecs-tasks"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  buildspec_file         = "buildspecs/verify-ecs-tasks-buildspec.yml"

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
}
