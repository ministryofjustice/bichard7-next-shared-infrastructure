module "nuke_sandbox" {
  for_each                       = { for s in local.nuke_vars : s.id => s }
  source                         = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  build_description              = "Run aws nuke over the sandboxes"
  codepipeline_s3_bucket         = module.codebuild_base_resources.codepipeline_bucket
  name                           = "nuke-${each.value.target}"
  repository_name                = "bichard7-next-infrastructure"
  buildspec_file                 = "nuke-sandboxes.yml"
  sns_notification_arn           = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn                = module.codebuild_base_resources.notifications_kms_key_arn
  aws_access_key_id_ssm_path     = "/nuke/user/access_key_id"
  aws_secret_access_key_ssm_path = "/nuke/user/secret_access_key"

  environment_variables = [
    {
      name  = "SANDBOX_ID"
      value = each.value.id
    },
    {
      name  = "SANDBOX_NAME"
      value = each.value.target
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = module.codebuild_base_resources.codepipeline_bucket
    }
  ]

  tags = module.label.tags
}

module "apply_nuke_sandbox_schedule" {
  for_each        = module.nuke_sandbox
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = each.value.pipeline_arn
  name            = each.value.pipeline_name
  cron_expression = "cron(0 0 ? * SAT *)" # run every Friday at midnight

  tags = module.label.tags
}
