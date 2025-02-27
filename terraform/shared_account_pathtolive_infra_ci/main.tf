module "tag_vars" {
  source = "../modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "pathtolive-ci"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = false
    "environment-name" = "pathtolive-ci"
    "account-name"     = "bichard7-shared"
    "provisioned-by"   = "shared_account_sandbox_infra code see make shared-account-pathtolive-infra-ci in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-shared-infrastructure/tree/main/shared_terraform/shared_account_pathtolive_ci"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.id
  }
}

module "codebuild_base_resources" {
  source = "../modules/codebuild_base_resources"

  aws_logs_bucket = data.terraform_remote_state.shared_infra.outputs.s3_logging_bucket_name
  name            = module.label.name
  slack_webhook   = var.slack_webhook

  allow_accounts                 = local.shared_resource_accounts
  codebuild_sg_environment_names = ["production", "pre-prod", "e2e-test", "uat", "leds"]

  tags = module.label.tags
}

module "codebuild_docker_resources" {
  source            = "../modules/aws_ecr_repositories"
  child_account_ids = local.shared_resource_accounts

  tags = module.label.tags

  depends_on = [
    module.codebuild_base_resources
  ]
}

module "common_build_jobs" {
  source                    = "../modules/shared_cd_common_jobs"
  codebuild_s3_bucket       = module.codebuild_base_resources.codepipeline_bucket
  notifications_kms_key_arn = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notifications_arn     = module.codebuild_base_resources.notifications_arn
  vpc_config_block          = module.codebuild_base_resources.codebuild_vpc_config_block
  environment               = local.environment
  bichard_cd_env_vars       = local.bichard_cd_vars
  audit_logging_cd_env_vars = local.bichard_cd_vars
  api_cd_env_vars           = local.bichard_cd_vars
  core_cd_env_vars          = local.bichard_cd_vars
  user_service_cd_env_vars  = local.bichard_cd_vars
  ui_cd_env_vars            = local.bichard_cd_vars
  beanconnect_cd_env_vars   = local.bichard_cd_vars
  reporting_cd_env_vars     = local.bichard_cd_vars
  common_cd_vars            = local.common_cd_vars
  scanning_results_bucket   = module.codebuild_base_resources.scanning_results_bucket

  tags = module.label.tags
}
