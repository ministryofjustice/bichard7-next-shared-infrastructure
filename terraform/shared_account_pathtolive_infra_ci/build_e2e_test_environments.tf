module "deploy_e2e_test_terraform" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-integration-next-e2e-test"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  build_timeout = 180

  build_environments = local.pipeline_build_environments

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
  deployment_name     = "e2e-test"
  event_type_ids      = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.liquibase_repository_arn,
    module.codebuild_docker_resources.amazon_linux_2_repository_arn,
    module.codebuild_docker_resources.nodejs_repository_arn,
    data.aws_ecr_repository.bichard.arn,
    data.aws_ecr_repository.codebuild_base.arn
  ]

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
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
      value = "/ci/certs/e2e-test/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/e2e-test/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/e2e-test/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/e2e-test/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/e2e-test/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
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
      value = "true"
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = module.codebuild_base_resources.codepipeline_bucket
    }
  ]
  is_cd = true

  tags = module.label.tags
}

module "destroy_e2e_test_terraform" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  build_description      = "Codebuild Pipeline for destroying e2e test terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "destroy-integration-next-e2e-test"
  buildspec_file         = "destroy-buildspec.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block

  build_timeout = 180

  deploy_account_name = "integration_next"
  deployment_name     = "e2e-test"

  build_environments = local.pipeline_build_environments

  allowed_resource_arns = [
    module.codebuild_docker_resources.liquibase_repository_arn,
    module.codebuild_docker_resources.amazon_linux_2_repository_arn,
    module.codebuild_docker_resources.nodejs_repository_arn,
    data.aws_ecr_repository.bichard.arn,
    data.aws_ecr_repository.codebuild_base.arn
  ]

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
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
      value = "/ci/certs/e2e-test/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/e2e-test/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/e2e-test/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/e2e-test/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/e2e-test/client1.domain.tld.key"
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

module "run_e2e_test_migrations" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  build_description      = "Codebuild job for running migrations against e2e-test"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-e2e-test-migrations"
  buildspec_file         = "buildspec-run-migrations.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block

  build_timeout = 180

  deploy_account_name = "integration_next"
  deployment_name     = "e2e-test"

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
      value = "e2e-test"
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

module "apply_dev_sg_to_e2e_test" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "apply-dev-sgs-to-e2e-test"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  build_environments = local.pipeline_build_environments

  deploy_account_name = "integration_next"
  deployment_name     = "e2e-test"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn
  ]

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
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

module "remove_dev_sg_from_e2e_test" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "remove-dev-sgs-from-e2e-test"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  build_environments = local.pipeline_build_environments

  deploy_account_name = "integration_next"
  deployment_name     = "e2e-test"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn
  ]

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
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

module "remove_dev_sg_from_e2e_test_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule?ref=upgrade-aws-provider"
  codebuild_arn   = module.remove_dev_sg_from_e2e_test.pipeline_arn
  name            = module.remove_dev_sg_from_e2e_test.pipeline_name
  cron_expression = "cron(0 01 * * ? *)"

  tags = module.label.tags
}
