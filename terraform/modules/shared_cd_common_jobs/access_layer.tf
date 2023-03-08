module "apply_access_layer" {
  depends_on = [
    aws_iam_user.ci_admin,
    aws_iam_access_key.ci_admin_user_key,
    aws_ssm_parameter.ci_admin_user_access_key_id,
    aws_ssm_parameter.ci_admin_user_secret_access_key
  ]

  source                         = "../codebuild_job"
  build_description              = "Apply the shared account infra layer on a schedule"
  codepipeline_s3_bucket         = var.codebuild_s3_bucket
  name                           = "apply-access-layer"
  sns_kms_key_arn                = var.notifications_kms_key_arn
  sns_notification_arn           = var.sns_notifications_arn
  repository_name                = "bichard7-next-shared-infrastructure"
  buildspec_file                 = "applyci-access.yml"
  aws_access_key_id_ssm_path     = aws_ssm_parameter.ci_admin_user_access_key_id.name
  aws_secret_access_key_ssm_path = aws_ssm_parameter.ci_admin_user_secret_access_key.name



  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    },
    {
      name  = "AUTO_APPROVE"
      value = true
    }
  ]

  tags = var.tags
}

module "apply_access_layer_schedule" {
  source          = "../codebuild_schedule"
  codebuild_arn   = module.apply_access_layer.pipeline_arn
  name            = module.apply_access_layer.pipeline_name
  cron_expression = "cron(0 23 * * ? *)"
  tags            = var.tags
}
