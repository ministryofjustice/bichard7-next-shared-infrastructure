data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "slack_webhook" {
  count           = local.is_production ? 1 : 0
  name            = "/lambda/slack/cloudwatch_alarms/webhook"
  with_decryption = true
}

data "aws_iam_policy" "allow_lambda_to_log" {
  name = "AWSLambdaBasicExecutionRole"
}

data "archive_file" "slack_webhook_notification" {
  count       = local.is_production ? 1 : 0
  output_path = "/tmp/slack_webhook_notification_rule.zip"
  type        = "zip"

  source {
    content = templatefile("${path.module}/source/webhook.py.tpl", {
      webhook_url                = data.aws_ssm_parameter.slack_webhook[count.index].value
      notifications_channel_name = var.notifications_channel_name
    })
    filename = "webhook.py"
  }
}
