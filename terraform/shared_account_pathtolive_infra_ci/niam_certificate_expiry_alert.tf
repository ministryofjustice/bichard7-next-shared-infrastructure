resource "aws_ssm_parameter" "niam_slack_webhook" {
  name  = "/monitoring/slack/niam_webhook"
  type  = "SecureString"
  value = "-"

  tags = module.label.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

module "niam_certificate_expiry_checker" {
  source                 = "../modules/codebuild_job"
  name                   = "check-niam-certificate-expiry"
  build_description      = "Checks SSM parameters for niam certificate expiration and alerts Slack"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  repository_name        = "bichard7-next-infrastructure"
  buildspec_file         = "buildspecs/niam-certificate-expiry-alert.yml"
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  build_environments = local.codebuild_2023_pipeline_build_environments

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  environment_variables = [
    {
      name  = "WARNING_DAYS"
      value = "30"
    },
    {
      name  = "SLACK_WEBHOOK_PARAM_PATH"
      value = aws_ssm_parameter.niam_slack_webhook.name
    },
    {
      name = "TARGET_ROLE_ARNS"
      value = [
        data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn,
        data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn,
        data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn,
        data.terraform_remote_state.shared_infra.outputs.production_ci_arn
      ]
    }
  ]

  tags = module.label.tags
}

module "run_niam_certificate_expiry_alert_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.niam_certificate_expiry_checker.pipeline_arn
  name            = "run-all-leds-e2e-tests-in-leds-env"
  cron_expression = "cron(0 9 * * ? *)" # daily at 9am UTC

  tags = module.label.tags
}
