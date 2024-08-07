resource "aws_ssm_parameter" "slack_webhook" {
  name      = "/ci/slack/webhook"
  type      = "SecureString"
  value     = var.slack_webhook
  overwrite = false

  tags = var.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_iam_policy" "allow_ci_ssm_access" {
  name = "${var.name}-allow-ci-slack-ssm"
  policy = templatefile("${path.module}/policies/allow_ci_ssm.json.tpl", {
    slack_webhook_arn = aws_ssm_parameter.slack_webhook.arn
  })

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "allow_ci_ssm_access" {
  user       = data.aws_iam_user.ci_user.user_name
  policy_arn = aws_iam_policy.allow_ci_ssm_access.arn
}

resource "aws_kms_key" "build_notifications_key" {
  description             = "${var.name}-codebuild-notifications-encryption-key"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  policy                  = local.allow_codestar_kms_policy

  tags = var.tags
}

resource "aws_kms_alias" "build_notifications_key_alias" {
  name          = "alias/codebuild-notifications"
  target_key_id = aws_kms_key.build_notifications_key.arn
}

resource "aws_sns_topic" "build_notifications" {
  name              = "${var.name}-codebuild-notifications"
  display_name      = title(replace("${var.name}-codebuild-notifications", "-", " "))
  kms_master_key_id = aws_kms_key.build_notifications_key.arn

  tags = var.tags
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.build_notifications.arn
  policy = templatefile("${path.module}/policies/allow_sns_policy.json.tpl", {
    sns_topic_arn = aws_sns_topic.build_notifications.arn
    account_id    = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "codebuild_notification" {
  name               = "AllowCodeBuildNotifications"
  assume_role_policy = file("${path.module}/policies/allow_codebuild_notification.json")

  tags = var.tags
}

#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "codebuild_notification" {
  function_name = "${var.name}-build-notifications"
  description   = "Allow sns notifications to push to a webhook"

  filename         = data.archive_file.codebuild_notification.output_path
  source_code_hash = data.archive_file.codebuild_notification.output_base64sha256
  handler          = "webhook.lambda_handler"

  role        = aws_iam_role.codebuild_notification.arn
  memory_size = "128"
  runtime     = "python3.12"
  timeout     = "5"

  tracing_config {
    mode = "PassThrough"
  }

  tags = var.tags
}

resource "aws_lambda_permission" "codebuild_notification" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codebuild_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.build_notifications.arn
}

resource "aws_sns_topic_subscription" "build_notice_subscription" {
  endpoint  = aws_lambda_function.codebuild_notification.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.build_notifications.arn
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "lambda_logging" {
  name        = "AllowLambdaLogging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = file("${path.module}/policies/allow_lambda_logging.json")

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.codebuild_notification.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
