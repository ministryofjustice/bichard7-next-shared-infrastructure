locals {
  remote_bucket_name = "cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate"
  sandbox_a_arn      = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.sandbox_a_ci_arn : data.terraform_remote_state.shared_infra.outputs.sandbox_a_admin_arn
  sandbox_b_arn      = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.sandbox_b_ci_arn : data.terraform_remote_state.shared_infra.outputs.sandbox_b_admin_arn
  sandbox_c_arn      = var.is_cd ? data.terraform_remote_state.shared_infra.outputs.sandbox_c_ci_arn : data.terraform_remote_state.shared_infra.outputs.sandbox_c_admin_arn
  environment        = "sandbox"



  nuke_vars = [
    {
      id     = data.aws_caller_identity.sandbox_a.account_id
      target = "sandbox-a"
    },
    {
      id     = data.aws_caller_identity.sandbox_b.account_id
      target = "sandbox-b"
    },
    {
      id     = data.aws_caller_identity.sandbox_c.account_id
      target = "sandbox-c"
    }
  ]

  # We're merging as we do in path to live, the variable is repeated in this list, but will be overwritten by the common
  # var list, if you want to add more vars to this add them to the empty set
  bichard_cd_vars = concat(
    [],
    local.common_cd_vars
  )

  common_cd_vars = [
    {
      name  = "ARTIFACT_BUCKET"
      value = module.codebuild_base_resources.codepipeline_bucket
    }
  ]
}
