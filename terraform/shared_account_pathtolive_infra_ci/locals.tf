locals {
  remote_bucket_name = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
  environment        = "pathtolive"

  integration_baseline_arn = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn : data.terraform_remote_state.shared_infra.outputs.integration_baseline_admin_arn
  integration_next_arn     = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn : data.terraform_remote_state.shared_infra.outputs.integration_next_admin_arn
  preprod_arn              = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn : data.terraform_remote_state.shared_infra.outputs.preprod_admin_arn
  production_arn           = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.production_ci_arn : data.terraform_remote_state.shared_infra.outputs.production_admin_arn

  bichard_cd_vars = concat(
    [
      {
        name  = "DEPLOY_NAME"
        value = "e2e-test"
      },
      {
        name  = "ASSUME_ROLE_ARN"
        value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
      },
      {
        name  = "ACCOUNT_NAME"
        value = "integration-next"
      },
      {
        name  = "IS_CD"
        value = "true"
      }
    ],
    local.common_cd_vars
  )

  common_cd_vars = [
    {
      name  = "ARTIFACT_BUCKET"
      value = module.codebuild_base_resources.codepipeline_bucket
    }
  ]

  shared_resource_accounts = sort([
    data.aws_caller_identity.current.account_id,
    data.aws_caller_identity.integration_baseline.account_id,
    data.aws_caller_identity.integration_next.account_id,
    data.aws_caller_identity.preprod.account_id,
    data.aws_caller_identity.production.account_id
  ])

  pipeline_build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_MEDIUM"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image                       = "${data.aws_ecr_repository.codebuild_base.repository_url}@${data.external.latest_codebuild_base.result.tags}"
      image_pull_credentials_type = "SERVICE_ROLE"
    }
  ]

  codebuild_2023_pipeline_build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_MEDIUM"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image                       = "${data.aws_ecr_repository.codebuild_2023_base.repository_url}@${data.external.latest_codebuild_2023_base.result.tags}"
      image_pull_credentials_type = "SERVICE_ROLE"
    }
  ]

  vpn_rotation_vars = [
    {
      id                  = "leds"
      target              = "leds"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
      workspace           = "leds"
      account_name        = "integration_baseline"
      deploy_name         = "leds"
      deploy_account_name = "integration_baseline"
      is_e2e              = false
      is_qsolution        = false
      is_production       = false
    },
    {
      id                  = "uat"
      target              = "uat"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
      workspace           = "uat"
      account_name        = "integration_baseline"
      deploy_name         = "uat"
      deploy_account_name = "integration_baseline"
      is_e2e              = false
      is_qsolution        = false
      is_production       = false
    },
    {
      id                  = data.aws_caller_identity.integration_next.account_id
      target              = "integration-next"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
      workspace           = "e2e-test"
      account_name        = "integration_next"
      deploy_name         = "e2e-test"
      deploy_account_name = "integration_next"
      is_e2e              = true
      is_qsolution        = false
      is_production       = false
    },
    {
      id                  = data.aws_caller_identity.preprod.account_id
      target              = "preprod"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
      workspace           = "preprod"
      account_name        = "preprod"
      deploy_name         = "preprod"
      deploy_account_name = "q_solution"
      is_e2e              = false
      is_qsolution        = true
      is_production       = true
    },
    {
      id                  = data.aws_caller_identity.production.account_id
      target              = "production"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
      workspace           = "production"
      account_name        = "production"
      deploy_name         = "production"
      deploy_account_name = "production"
      is_e2e              = false
      is_qsolution        = true
      is_production       = true
    }
  ]

  latest_liquibase_image         = "${data.aws_ecr_repository.liquibase.repository_url}@${data.external.latest_liquibase.result.tags}"
  latest_scoutsuite_image        = "${data.aws_ecr_repository.scoutsuite.repository_url}@${data.external.latest_scoutsuite.result.tags}"
  latest_zap_owasp_scanner_image = "${data.aws_ecr_repository.zap_owasp_scanner.repository_url}@${data.external.latest_zap_owasp_scanner.result.tags}"

  allow_codebuild_codestar_connection_policy = templatefile("${path.module}/policies/allow_codebuild_codestar_connection.json", {
    codestar_arn = aws_codestarconnections_connection.github.id
  })
  kms_permissions_policy = templatefile(
    "${path.module}/policies/codebuild_kms_permissions.json",
    {
      account_id = data.aws_caller_identity.current.account_id
    }
  )
}