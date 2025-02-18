module "run_e2e_tests" {
  source            = "../modules/codebuild_job"
  name              = "integration-test-e2e-test"
  build_description = "Codebuild Pipeline Running integration tests against e2e-test"
  repository_name   = "bichard7-next-core"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_blocks["e2e-test"]

  report_build_status = true

  buildspec_file = "packages/e2e-test/e2eTestBuildspec.yml"
  event_type_ids = []

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_MEDIUM"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
    },
    {
      name  = "STACK_TYPE"
      value = "next"
    },
    {
      name  = "AWS_URL"
      value = "none"
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

module "run_e2e_tests_restart_pnc_container" {
  source            = "../modules/codebuild_job"
  name              = "restart-e2e-test-pnc-emulator-container"
  build_description = "Terminate the PNC emulator container so that it will restart automatically"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/restart-pnc-buildspec.yml"

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
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
