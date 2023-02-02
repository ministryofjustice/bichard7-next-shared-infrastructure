module "nuke_sandbox" {
  source                         = "../modules/codebuild_job"
  build_description              = "Run aws nuke over the sandboxes"
  codepipeline_s3_bucket         = module.codebuild_base_resources.codepipeline_bucket
  name                           = "rotate-vpn-keys"
  repository_name                = "bichard7-next-infrastructure"
  buildspec_file                 = "buildspecs/rotate-vpn-keys-buildspec.yml"
  sns_notification_arn           = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn                = module.codebuild_base_resources.notifications_kms_key_arn

  environment_variables = []

  tags = module.label.tags
}
