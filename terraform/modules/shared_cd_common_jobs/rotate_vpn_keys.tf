module "rotate_vpn_keys" {
  source                 = "../modules/codebuild_job"
  build_description      = "Rotate VPN keys"
  codepipeline_s3_bucket = var.codebuild_s3_bucket
  name                   = "nuke-${each.value.target}"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/rotate-vpn-keys-buildspec.yml"
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  environment_variables = []

  tags = var.tags
}

module "apply_rotate_vpn_keys_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.rotate_vpn_keys.pipeline_arn
  name            = module.rotate_vpn_keys.pipeline_name
  cron_expression = "cron(0 0 ? * SAT *)" # run every Friday at midnight

  tags = var.tags
}
