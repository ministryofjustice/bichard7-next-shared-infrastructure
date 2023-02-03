module "rotate_vpn_keys" {
  for_each               = { for s in local.vpn_rotation_vars : s.id => s }
  source                 = "../modules/codebuild_job"
  build_description      = "Rotate VPN keys for ${each.value.target}"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "rotate-${each.value.target}-vpn-keys"
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/rotate-vpn-keys-buildspec.yml"
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  build_environments = local.pipeline_build_environments

  deploy_account_name = each.value.deploy_account_name
  deployment_name     = each.value.deploy_name
  event_type_ids      = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.liquibase_repository_arn,
    module.codebuild_docker_resources.amazon_linux_2_repository_arn,
    module.codebuild_docker_resources.nodejs_repository_arn,
    data.aws_ecr_repository.bichard.arn,
    data.aws_ecr_repository.codebuild_base.arn
  ]

  environment_variables = [
    {
      name  = "ASSUME_ROLE_ARN"
      value = each.value.role_arn
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
