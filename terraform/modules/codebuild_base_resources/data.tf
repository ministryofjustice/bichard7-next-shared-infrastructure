data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "slack_webhook" {
  name            = aws_ssm_parameter.slack_webhook.name
  with_decryption = true
}

#tfsec:ignore:aws-iam-no-user-attached-policies
data "aws_iam_user" "ci_user" {
  user_name = "cjse.ci"
}

# Lambdas
data "archive_file" "codebuild_notification" {
  output_path = "/tmp/codebuild_notification_rule.zip"
  type        = "zip"

  source {
    content = templatefile("${path.module}/source/webhook.py.tpl", {
      webhook_url  = data.aws_ssm_parameter.slack_webhook.value
      channel_name = var.notifications_channel_name
    })
    filename = "webhook.py"
  }
}

data "archive_file" "scanning_notification" {
  output_path = "/tmp/scanning_notification_rule.zip"
  type        = "zip"

  source {
    content = templatefile("${path.module}/source/scanning_webhook.py.tpl", {
      webhook_url  = data.aws_ssm_parameter.slack_webhook.value
      channel_name = var.notifications_channel_name
    })
    filename = "webhook.py"
  }
}
