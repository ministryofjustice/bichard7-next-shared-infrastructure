locals {
  remote_bucket_name = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
  public_dns_name    = lower("cd.${data.terraform_remote_state.shared_infra.outputs.delegated_hosted_zone.name}")
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

  vpn_rotation_vars = [
    {
      id                  = data.aws_caller_identity.integration_next.account_id
      target              = "integration-next"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
      workspace           = "e2e-test"
      account_name        = "integration_next"
      deploy_name         = "e2e-test"
      deploy_account_name = "integration_next"
    },
    {
      id                  = data.aws_caller_identity.preprod.account_id
      target              = "preprod"
      role_arn            = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
      workspace           = "pre-prod"
      account_name        = "preprod"
      deploy_name         = "preprod"
      deploy_account_name = "q_solution"
    },
    # {
    #   id           = data.aws_caller_identity.production.account_id
    #   target       = "production"
    #   role_arn     = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
    #   workspace    = "production"
    #   account_name = "production"
    #   deploy_name  = "production"
    #   deploy_account_name = "production"
    # }
  ]
}
