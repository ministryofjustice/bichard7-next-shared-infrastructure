module "deploy_production_terraform" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-qsolution-production"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/buildspec.yml"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]
  event_type_ids         = []

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
  deploy_account_name = "production"
  deployment_name     = "production"

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
      value = "production"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "CA_CERT"
      value = "/ci/certs/production/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/production/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/production/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/production/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/production/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "TF_VAR_override_deploy_tags"
      value = "true"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
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
      value = "false"
    },
    {
      name  = "TF_VAR_host9_endpoint_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-01207f79bd9f005a0"
    },
    {
      name  = "TF_VAR_host9_egress_cidr"
      value = "[\"51.231.76.64/27\", \"51.231.76.96/27\"]"
    },
    {
      name  = "TF_VAR_host9_egress_internal_cidr"
      value = "10.3.134.128/28"
    },
    {
      name  = "TF_VAR_elasticsearch_instance_type"
      value = "r5.xlarge.elasticsearch"
    },
    {
      name  = "TF_VAR_elasticsearch_ebs_volume_size"
      value = 1500
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
      name  = "USE_SMTP"
      value = "true"
    },
    {
      name  = "TF_VAR_desired_application_instance_count"
      value = 9 # Three per AZ
    },
    {
      name  = "TF_VAR_desired_web_application_instance_count"
      value = 9 # Three per AZ
    },
    {
      name  = "TF_VAR_desired_backend_application_instance_count"
      value = 6 # Three per AZ
    },
    {
      name  = "TF_VAR_desired_pnc_api_instance_count"
      value = 3 # Three per AZ
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
      name  = "TF_VAR_use_smtp_service"
      value = "true"
    },
    {
      name  = "TF_VAR_deploy_bastion"
      value = "false"
    },
    {
      name  = "TF_VAR_external_s3_ingress_account_id"
      value = "651649287817"
    },
    {
      name  = "TF_VAR_pagerduty_integration"
      value = "true"
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

module "destroy_production_terraform" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "destroy-qsolution-production"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  buildspec_file       = "buildspecs/destroy-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

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
      value = "production"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "CA_CERT"
      value = "/ci/certs/production/ca.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_CERT"
      value = "/ci/certs/production/server.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SERVER_KEY"
      value = "/ci/certs/production/server.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_CERT"
      value = "/ci/certs/production/client1.domain.tld.crt"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "CLIENT_KEY"
      value = "/ci/certs/production/client1.domain.tld.key"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
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
      name  = "TF_VAR_host9_endpoint_service_name"
      value = "com.amazonaws.vpce.eu-west-2.vpce-svc-01207f79bd9f005a0"
    }
  ]

  tags = module.label.tags
}

module "apply_dev_sg_to_prod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "apply-dev-sgs-to-prod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  buildspec_file       = "buildspecs/vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

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
      value = "production"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
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

module "remove_dev_sg_from_prod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "remove-dev-sgs-from-prod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  buildspec_file       = "buildspecs/vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

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
      value = "production"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
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

module "remove_dev_sg_from_prod_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.remove_dev_sg_from_prod.pipeline_arn
  name            = module.remove_dev_sg_from_prod.pipeline_name
  cron_expression = "cron(0 01 * * ? *)"

  tags = module.label.tags
}

module "run_production_migrations" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild job for running migrations against production environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-production-migrations"
  buildspec_file         = "buildspecs/buildspec-run-migrations.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

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
      value = "production"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
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

module "deploy_production_conductor_definitions" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild job for updating JSON definitions for workflows, tasks and event listeners in Conductor"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-production-conductor-definitions"
  buildspec_file         = "buildspecs/deploy-conductor-definitions.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

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
      value = "production"
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
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

module "enable_maintenance_page_prod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for enabling maintenance page in prod"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "enable-maintenance-page-prod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  buildspec_file       = "buildspecs/maintenance-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "production"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
    },
    {
      name  = "ENABLE_MAINTENANCE"
      value = "true"
    }
  ]

  tags = module.label.tags
}

module "disable_maintenance_page_prod" {
  source = "../modules/codebuild_job"

  build_description      = "Codebuild Pipeline for disabling maintenance page in prod"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "disable-maintenance-page-prod"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  buildspec_file       = "buildspecs/maintenance-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "production"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
    },
    {
      name  = "ENABLE_MAINTENANCE"
      value = "false"
    }
  ]

  tags = module.label.tags
}
