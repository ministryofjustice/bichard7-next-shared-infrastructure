module "run_load_tests" {
  source            = "../modules/codebuild_job"
  name              = "run-load-test"
  build_description = "Codebuild Pipeline Running load tests against load-test environment"
  repository_name   = "bichard7-next-tests"

  report_build_status = true

  buildspec_file = "LoadTestBuildspec.yml"
  event_type_ids = []

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn
  ]

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_LARGE"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    }
  ]

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
    },
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "load-test"
    },
    {
      name  = "STACK_TYPE"
      value = "next"
    }
  ]
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "run_load_tests_terminate_pnc_container" {
  source            = "../modules/codebuild_job"
  name              = "restart-load-test-pnc-emulator-container"
  build_description = "Terminate the PNC emulator container so that it will restart automatically"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/restart-pnc-buildspec.yml"

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
    },
    {
      name  = "WORKSPACE"
      value = "load-test"
    },
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn


  tags = module.label.tags
}
