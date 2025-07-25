module "deploy_preprod_terraform" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-qsolution-preprod"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/buildspec.yml"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  build_environments = local.pipeline_build_environments

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
  deploy_account_name = "q_solution"
  deployment_name     = "preprod"
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
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "CA_CERT"
      value = "/ci/certs/qsolution/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/qsolution/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/qsolution/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/qsolution/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/qsolution/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "TF_VAR_override_deploy_tags"
      value = "true"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
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
      name  = "TF_VAR_is_qsolution"
      value = true
    },
    {
      name  = "TF_VAR_is_production"
      value = true
    },
    {
      name  = "TF_VAR_pnc_ip"
      value = "172.31.4.204"
    },
    {
      name  = "TF_VAR_pnc_lpap"
      value = "LPBICHCJ"
    },
    {
      name  = "TF_VAR_pnc_aeq"
      value = "7703"
    },
    {
      name  = "TF_VAR_pnc_contwin"
      value = "1"
    },
    {
      name  = "TF_VAR_pnc_proxy_hostname"
      value = "BC61C"
    },
    {
      name  = "USE_PEERING"
      value = "true"
    },
    {
      name  = "TF_VAR_pnc_vpc_cidr_ingress"
      value = "true"
    },
    {
      name  = "TF_VAR_host9_endpoint_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-088c78cdc790caaeb"
    },
    {
      name  = "TF_VAR_host9_testing_tool_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-0c8c75e097f908968"
    },
    {
      name  = "USE_SMTP"
      value = "true"
    },
    {
      name  = "TF_VAR_use_smtp_service"
      value = "true"
    },
    {
      name  = "TF_VAR_deploy_bastion"
      value = "false"
    },
    {
      name  = "TF_VAR_external_s3_ingress_account_id"
      value = "336267957755"
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = module.codebuild_base_resources.codepipeline_bucket
    },
    {
      name  = "TF_VAR_aurora_db_version"
      value = "15.10"
    },
  ]

  tags = module.label.tags
}

module "destroy_preprod_terraform" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "destroy-qsolution-preprod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/destroy-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

  build_environments = local.pipeline_build_environments

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
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "CA_CERT"
      value = "/ci/certs/qsolution/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/qsolution/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/qsolution/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/qsolution/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/qsolution/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "TF_VAR_is_qsolution"
      value = true
    },
    {
      name  = "TF_VAR_is_production"
      value = true
    },
    {
      name  = "TF_VAR_pnc_ip"
      value = "172.31.4.204"
    },
    {
      name  = "TF_VAR_pnc_lpap"
      value = "LPBICHCJ"
    },
    {
      name  = "TF_VAR_pnc_aeq"
      value = "7703"
    },
    {
      name  = "TF_VAR_pnc_contwin"
      value = "1"
    },
    {
      name  = "USE_PEERING"
      value = "true"
    },
    {
      name  = "TF_VAR_host9_endpoint_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-088c78cdc790caaeb"
    },
    {
      name  = "TF_VAR_host9_testing_tool_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-0c8c75e097f908968"
    }
  ]

  tags = module.label.tags
}

module "run_preprod_tests" {
  source            = "../modules/codebuild_job"
  name              = "integration-test-preprod"
  build_description = "Codebuild Pipeline Running integration tests against preprod"
  repository_name   = "bichard7-next-core"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

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
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
    },
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "preprod"
    },
    {
      name  = "STACK_TYPE"
      value = "next"
    },
    {
      name  = "TEST_COMMAND"
      value = "test:preprod"
    },
    {
      name  = "AL_TEST_COMMAND"
      value = "test:preprodauditlogs"
    },
    {
      name  = "REAL_PNC"
      value = "true"
    },
    {
      name  = "PNC_TEST_TOOL"
      value = "https://10.129.3.73/"
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

module "run_preprod_migrations" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild job for running migrations against preprod environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-preprod-migrations"
  buildspec_file         = "buildspecs/buildspec-run-migrations.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

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
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
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

module "deploy_preprod_conductor_definitions" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild job for updating JSON definitions for workflows, tasks and event listeners in Conductor"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-preprod-conductor-definitions"
  buildspec_file         = "buildspecs/deploy-conductor-definitions.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

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
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
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
  tags = module.label.tags
}

module "apply_dev_sg_to_preprod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "apply-dev-sgs-to-preprod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.pipeline_build_environments

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
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

module "remove_dev_sg_from_preprod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "remove-dev-sgs-from-preprod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.pipeline_build_environments

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
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

module "remove_dev_sg_from_preprod_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.remove_dev_sg_from_preprod.pipeline_arn
  name            = module.remove_dev_sg_from_preprod.pipeline_name
  cron_expression = "cron(0 01 * * ? *)"

  tags = module.label.tags
}

module "enable_maintenance_page_preprod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for enabling maintenance page in preprod"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "enable-maintenance-page-preprod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/maintenance-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "preprod"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
    },
    {
      name  = "ENABLE_MAINTENANCE"
      value = "true"
    }
  ]

  tags = module.label.tags
}

module "disable_maintenance_page_preprod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for disabling maintenance page in preprod"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "disable-maintenance-page-preprod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/maintenance-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "preprod"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
    },
    {
      name  = "ENABLE_MAINTENANCE"
      value = "false"
    }
  ]

  tags = module.label.tags
}

module "enable_pnc_test_tool" {
  source                 = "../modules/codebuild_job"
  build_description      = "Enable PNC test tool in pre production"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "enable-pnc-test-tool"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/pnc-test-tool-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn

  build_environments = local.pipeline_build_environments

  allowed_resource_arns = [
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
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "TF_VAR_pnc_test_tool_enabled"
      value = true
    },
    {
      name  = "TF_VAR_host9_testing_tool_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-0c8c75e097f908968"
    },
  ]

  tags = module.label.tags
}

module "disable_pnc_test_tool" {
  source                 = "../modules/codebuild_job"
  build_description      = "Disable PNC test tool in pre production"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "disable-pnc-test-tool"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]


  buildspec_file       = "buildspecs/pnc-test-tool-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn

  build_environments = local.pipeline_build_environments

  allowed_resource_arns = [
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
      value = "preprod"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "q_solution"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "TF_VAR_pnc_test_tool_enabled"
      value = false
    },
    {
      name  = "TF_VAR_host9_testing_tool_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-0c8c75e097f908968"
    },
  ]

  tags = module.label.tags
}

module "optimise_preprod_db" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for optimising preprod database"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "optimise-preprod-db"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["pre-prod"]

  buildspec_file       = "buildspecs/optimise-db.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  build_environments = local.codebuild_2023_pipeline_build_environments

  deploy_account_name = "q_solution"
  deployment_name     = "preprod"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
    },
    {
      name  = "WORKSPACE"
      value = "preprod"
    },
  ]

  tags = module.label.tags
}
