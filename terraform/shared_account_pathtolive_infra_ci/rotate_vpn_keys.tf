module "rotate_vpn_keys" {
  for_each               = { for s in local.rotate_vpn_keys : s.id => s }
  source                 = "../modules/codebuild_job"
  build_description      = "Rotate VPN keys"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "rotate-${each.value.target}-vpn-keys"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/rotate-vpn-keys-buildspec.yml"
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = each.value.role_arn
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
    },
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = each.value.workspace
    },
    {
      name  = "USER_TYPE"
      value = "ci"
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = each.value.account_name
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    }
  ]

  tags = module.label.tags
}
