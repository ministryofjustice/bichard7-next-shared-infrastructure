module "deploy_integration_test_terraform" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-integration-next-int-test"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  build_timeout = 180
  codebuild_secondary_sources = [
    {
      type              = "GITHUB"
      location          = "https://github.com/ministryofjustice/bichard7-next.git"
      git_clone_depth   = 1
      source_identifier = "bichard7_next"
      git_submodules_config = {
        fetch_submodules = true
      }
    }
  ]
  deploy_account_name = "integration_next"
  deployment_name     = "int-test"
  event_type_ids      = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.liquibase_repository_arn,
    module.codebuild_docker_resources.amazon_linux_2_repository_arn,
    module.codebuild_docker_resources.nodejs_repository_arn,
    data.aws_ecr_repository.bichard.arn
  ]
  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "int-test"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_next"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "CA_CERT"
      value = "/ci/certs/integration-test/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/integration-test/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/integration-test/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/integration-test/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/integration-test/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "BICHARD_DEPLOY_TAG"
      value = data.external.latest_bichard_image.result.tags
    },
    {
      name  = "TF_VAR_override_deploy_tags"
      value = "true"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "LIQUIBASE_IMAGE"
      value = module.codebuild_docker_resources.liquibase_docker_image
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "USE_PEERING"
      value = "true"
    },
    {
      name  = "USE_SMTP"
      value = "false"
    }
  ]
  is_cd = true

  tags = module.label.tags
}

module "destroy_integration_test_terraform" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "destroy-integration-next-int-test"
  buildspec_file         = "destroy-buildspec.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block

  build_timeout = 180

  deploy_account_name = "integration_next"
  deployment_name     = "int-test"
  allowed_resource_arns = [
    module.codebuild_docker_resources.liquibase_repository_arn,
    module.codebuild_docker_resources.amazon_linux_2_repository_arn,
    module.codebuild_docker_resources.nodejs_repository_arn,
    data.aws_ecr_repository.bichard.arn
  ]
  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "int-test"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_next"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "CA_CERT"
      value = "/ci/certs/integration-test/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/integration-test/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/integration-test/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/integration-test/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/integration-test/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "USE_PEERING"
      value = "true"
    }
  ]
  is_cd = true
  tags  = module.label.tags
}

module "run_integration_tests" {
  source            = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  name              = "int-test-int-test"
  build_description = "Codebuild Pipeline Running integration tests against int-test"
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
      value = "int-test"
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

module "run_integration_test_migrations" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild job for running migrations against integration test environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-integration-test-migrations"
  buildspec_file         = "buildspec-run-migrations.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block
  event_type_ids       = []
  build_timeout        = 180

  deploy_account_name = "integration_next"
  deployment_name     = "int-test"

  codebuild_secondary_sources = [
    {
      type              = "GITHUB"
      location          = "https://github.com/ministryofjustice/bichard7-next.git"
      git_clone_depth   = 1
      source_identifier = "bichard7_next"
      git_submodules_config = {
        fetch_submodules = true
      }
    }
  ]

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "int-test"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_next"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "USE_PEERING"
      value = "true"
    },
    {
      name  = "LIQUIBASE_IMAGE"
      value = module.codebuild_docker_resources.liquibase_docker_image
    }
  ]
  tags = module.label.tags
}

module "run_integration_tests_restart_pnc_container" {
  source            = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  name              = "restart-int-test-pnc-emulator-container"
  build_description = "Terminate the PNC emulator container so that it will restart automatically"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "restart-pnc-buildspec.yml"
  event_type_ids    = []

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "WORKSPACE"
      value = "int-test"
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

module "apply_dev_sg_to_int_test" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "apply-dev-sgs-to-int-test"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name   = "integration_next"
  deployment_name       = "int-test"
  allowed_resource_arns = []
  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "int-test"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_next"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "SG_COMMAND"
      value = "dev-sg-rules"
    }
  ]

  tags = module.label.tags
}

module "remove_dev_sg_from_int_test" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "remove-dev-sgs-from-int-test"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name   = "integration_next"
  deployment_name       = "int-test"
  allowed_resource_arns = []
  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "int-test"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_next"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "SG_COMMAND"
      value = "destroy-dev-sg-rules"
    }
  ]

  tags = module.label.tags
}

module "remove_dev_sg_from_int_test_schedule" {
  count = 0 # Disabled until we start using the develop pipeline

  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.remove_dev_sg_from_int_test.pipeline_arn
  name            = module.remove_dev_sg_from_int_test.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"

  tags = module.label.tags
}
