module "verify_ecs_tasks" {
  source = "../modules/codebuild_job"

  build_description      = "Verifies ECS tasks are healthy and using correct task definitions"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "verify-ecs-tasks"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  buildspec_file         = "buildspecs/verify-ecs-tasks-buildspec.yml"
  event_type_ids         = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.codebuild_2023_pipeline_build_environments

  tags = module.label.tags
}
