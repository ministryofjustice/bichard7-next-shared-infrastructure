module "run_e2e_tests" {
  source            = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  name              = "integration-test-e2e-test"
  build_description = "Codebuild Pipeline Running integration tests against e2e-test"
  repository_name   = "bichard7-next-tests"

  report_build_status = true

  buildspec_file = "e2eTestBuildspec.yml"
  event_type_ids = []

  allowed_resource_arns = [
    data.aws_ecr_repository.nodejs.arn
  ]

  build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_SMALL"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image                       = "${data.aws_ecr_repository.nodejs.repository_url}@${data.external.latest_nodejs_image.result.tags}"
      image_pull_credentials_type = "SERVICE_ROLE"

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

module "run_e2e_tests_schedule" {
  count           = 0 // We are disabling this for now as it interferes with the pipeline testing, we'll probably remove it
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.run_e2e_tests.pipeline_arn
  name            = module.run_e2e_tests.pipeline_name
  cron_expression = "cron(30 8-18 ? * MON-FRI *)"

  tags = module.label.tags
}

resource "aws_codebuild_webhook" "e2e_tests_pr_webhook" {
  project_name = module.run_e2e_tests.pipeline_name

  # Run the tests when a PR is created or updated and is not the master branch
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED"
    }

    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_UPDATED"
    }

    filter {
      type                    = "HEAD_REF"
      pattern                 = "refs/heads/master"
      exclude_matched_pattern = true
    }
  }

  # Run the tests when the master branch is updated from a merge or a naughty force push
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "refs/heads/master"
    }
  }

}

module "run_e2e_tests_restart_pnc_container" {
  source            = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  name              = "restart-e2e-test-pnc-emulator-container"
  build_description = "Terminate the PNC emulator container so that it will restart automatically"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "restart-pnc-buildspec.yml"

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
