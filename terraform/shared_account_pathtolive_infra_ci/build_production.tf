module "deploy_production_terraform" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-qsolution-production"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block
  event_type_ids         = []

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]
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
      value = module.codebuild_docker_resources.liquibase_docker_image
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
      name  = "TF_VAR_grafana_db_instance_class"
      value = "db.r5.large"
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
    }
  ]

  tags = module.label.tags
}

module "destroy_production_terraform" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "destroy-qsolution-production"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "destroy-buildspec.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"
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
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "elevate-prod-access-to-vpn-users"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name   = "production"
  deployment_name       = "production"
  allowed_resource_arns = []
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
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild Pipeline for rebuilding terraform infrastructure"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "remove-elevated-prod-access-from-vpn-users"
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block

  buildspec_file       = "vpc-sg-access.yml"
  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn

  build_timeout = 180

  deploy_account_name   = "production"
  deployment_name       = "production"
  allowed_resource_arns = []
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
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.remove_dev_sg_from_prod.pipeline_arn
  name            = module.remove_dev_sg_from_prod.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"

  tags = module.label.tags
}

module "reset_production_smtp_bastion" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Re-apply the smtp-service layer to ensure that the bastion asg is set to 0"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "reset-production-bastion-asg"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_block
  buildspec_file         = "reset-bastion-asg-buildspec.yml"
  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]
  build_timeout = 180

  deploy_account_name = "production"
  deployment_name     = "production"
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
      name  = "TF_VAR_deploy_bastion"
      value = "false"
    }
  ]

  tags = module.label.tags
}

module "reset_production_smtp_bastion_schedule" {
  count           = 0
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.reset_production_smtp_bastion.pipeline_arn
  name            = module.reset_production_smtp_bastion.pipeline_name
  cron_expression = "cron(0 0 * * ? *)"

  tags = module.label.tags
}

module "deploy_production_smtp_service" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild job for applying smtp layer against production environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-production-smtp"
  buildspec_file         = "buildspec-layer.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block

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
      name  = "USE_SMTP"
      value = "true"
    },
    {
      name  = "LAYER"
      value = "smtp-service"
    }
  ]
  tags = module.label.tags
}

module "deploy_production_monitoring_layer" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild job for applying monitoring layer against production environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploy-production-monitoring"
  buildspec_file         = "buildspec-layer.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block

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
      name  = "TF_VAR_elasticsearch_instance_type"
      value = "r5.xlarge.elasticsearch"
    },
    {
      name  = "TF_VAR_elasticsearch_ebs_volume_size"
      value = 1500
    },
    {
      name  = "TF_VAR_grafana_db_instance_class"
      value = "db.r5.large"
    },
    {
      name  = "LAYER"
      value = "monitoring"
    }
  ]
  tags = module.label.tags
}


module "run_production_migrations" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Codebuild job for running migrations against production environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-production-migrations"
  buildspec_file         = "buildspec-run-migrations.yml"

  repository_name      = "bichard7-next-infrastructure"
  sns_kms_key_arn      = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn = module.codebuild_base_resources.notifications_arn
  vpc_config           = module.codebuild_base_resources.codebuild_vpc_config_block

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
      value = module.codebuild_docker_resources.liquibase_docker_image
    }
  ]
  tags = module.label.tags
}
