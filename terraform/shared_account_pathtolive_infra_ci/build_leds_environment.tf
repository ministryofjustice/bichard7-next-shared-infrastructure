module "deploy_leds_test_environment_terraform" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding leds test environment terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-leds-test-environment-terraform"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["leds"]
  buildspec_file         = "buildspecs/buildspec.yml"

  build_timeout = 180

  build_environments = local.codebuild_2023_pipeline_build_environments

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

  deploy_account_name = "integration_baseline"
  deployment_name     = "leds"
  event_type_ids      = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.liquibase_repository_arn,
    module.codebuild_docker_resources.amazon_linux_2_repository_arn,
    data.aws_ecr_repository.bichard.arn,
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "leds"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_baseline"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
    },
    {
      name  = "LIQUIBASE_IMAGE"
      value = local.latest_liquibase_image
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
      name  = "TF_VAR_broker_instance_type"
      value = "mq.m5.large"
    },
    {
      name  = "TF_VAR_db_instance_class"
      value = "db.r5.large"
    },
    {
      name  = "TF_VAR_desired_application_instance_count"
      value = 9 # Three per AZ
    },
    {
      name  = "TF_VAR_desired_portal_instance_count"
      value = 3 # One per AZ
    },
    {
      name  = "TF_VAR_desired_user_service_instance_count"
      value = 3 # One per AZ
    },
    {
      name  = "TF_VAR_desired_auth_proxy_instance_count"
      value = 3 # One per AZ
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = module.codebuild_base_resources.codepipeline_bucket
    },
    {
      name  = "TF_VAR_aurora_db_version"
      value = "15.12"
    }
  ]

  tags = module.label.tags
}

module "run_leds_tests" {
  source            = "../modules/codebuild_job"
  name              = "integration-test-leds"
  build_description = "Codebuild Pipeline Running integration tests against LEDS API"
  repository_name   = "bichard7-next-core"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_blocks["leds"]

  report_build_status = true

  buildspec_file = "packages/e2e-test/e2eTestBuildspec.yml"
  event_type_ids = []

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.codebuild_2023_pipeline_build_environments

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
      value = "leds"
    },
    {
      name  = "STACK_TYPE"
      value = "next"
    },
    {
      name  = "TEST_COMMAND"
      value = "test:leds:preprod"
    },
    {
      name  = "AL_TEST_COMMAND"
      value = "test:leds:preprodauditlogs"
    },
    {
      name  = "REAL_POLICE_API"
      value = "true"
    },
    {
      name  = "USE_LEDS"
      value = "true"
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

module "run_leds_test_migrations" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild job for running migrations against leds test environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-leds-test-migrations"
  buildspec_file         = "buildspecs/buildspec-run-migrations.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_blocks["leds"]

  build_timeout = 180

  deploy_account_name = "integration_baseline"
  deployment_name     = "leds"

  codebuild_secondary_sources = [
    {
      type              = "GITHUB"
      location          = "https://github.com/ministryofjustice/bichard7-next.git"
      git_clone_depth   = 1
      source_identifier = "bichard7_next"
      git_submodules_config = {
        fetch_submodules = true
      }
    },
    {
      type              = "GITHUB"
      location          = "https://github.com/ministryofjustice/bichard7-next-core.git"
      git_clone_depth   = 1
      source_identifier = "bichard7_next_core"
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
      value = "leds"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_baseline"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
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
      value = local.latest_liquibase_image
    }
  ]
  tags = module.label.tags
}

module "deploy_leds_conductor_definitions" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild job for updating JSON definitions for workflows, tasks and event listeners in Conductor"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-leds-conductor-definitions"
  buildspec_file         = "buildspecs/deploy-conductor-definitions.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_blocks["leds"]

  build_timeout = 180

  deploy_account_name = "integration_baseline"
  deployment_name     = "leds"

  codebuild_secondary_sources = [
    {
      type              = "GITHUB"
      location          = "https://github.com/ministryofjustice/bichard7-next-core.git"
      git_clone_depth   = 1
      source_identifier = "bichard7_next_core"
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
      value = "leds"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_baseline"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
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
      name  = "INCOMING_MESSAGE_SQS_QUEUE"
      value = "bichard-7-leds-incomingMessageQueue"
    }
  ]
  tags = module.label.tags
}

module "apply_dev_sg_to_leds_test" {
  source = "../modules/codebuild_job"

  build_description      = "Apply dev security groups to leds test environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "apply-dev-sgs-to-leds-test"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["leds"]

  buildspec_file       = "buildspecs/vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "integration_baseline"
  deployment_name     = "leds"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.codebuild_2023_pipeline_build_environments

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "leds"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_baseline"
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

module "remove_dev_sg_from_leds_test" {
  source = "../modules/codebuild_job"

  build_description      = "Remove dev security groups to leds test environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "remove-dev-sgs-from-leds-test"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["leds"]

  buildspec_file       = "buildspecs/vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "integration_baseline"
  deployment_name     = "leds"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.codebuild_2023_pipeline_build_environments

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "leds"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "integration_baseline"
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
