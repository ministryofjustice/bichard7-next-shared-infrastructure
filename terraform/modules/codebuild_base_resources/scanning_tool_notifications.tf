resource "aws_kms_key" "scanning_notifications_key" {
  description             = "${var.name}-scanning-notifications-encryption-key"
  enable_key_rotation     = true
  policy                  = local.allow_codestar_kms_policy
  deletion_window_in_days = 10

  tags = var.tags
}

resource "aws_kms_alias" "scanning_notifications_key_alias" {
  name          = "alias/scanning-notifications"
  target_key_id = aws_kms_key.scanning_notifications_key.arn
}

resource "aws_sns_topic" "scanning_notifications" {
  name              = "${var.name}-scanning-notifications"
  display_name      = title(replace("${var.name}-scanning-notifications", "-", " "))
  kms_master_key_id = aws_kms_key.scanning_notifications_key.arn

  tags = var.tags
}

resource "aws_sns_topic_policy" "scanning_notifications" {
  arn    = aws_sns_topic.scanning_notifications.arn
  policy = templatefile("${path.module}/policies/allow_sns_policy.json.tpl", {
    sns_topic_arn = aws_sns_topic.scanning_notifications.arn
    account_id    = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "scanning_notification" {
  name               = "AllowScanningNotifications"
  assume_role_policy = file("${path.module}/policies/allow_codebuild_notification.json")

  tags = var.tags
}

#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "scanning_notification" {
  function_name = "${var.name}-scanning-notifications"
  description   = "Allow sns notifications to push to a webhook"

  filename         = data.archive_file.scanning_notification.output_path
  source_code_hash = data.archive_file.scanning_notification.output_base64sha256
  handler          = "webhook.lambda_handler"

  role        = aws_iam_role.scanning_notification.arn
  memory_size = "128"
  runtime     = "python3.8"
  timeout     = "5"

  tracing_config {
    mode = "PassThrough"
  }

  tags = var.tags
}

resource "aws_lambda_permission" "scanning_notification" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scanning_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.scanning_notifications.arn
}

resource "aws_sns_topic_subscription" "scanning_notice_subscription" {
  endpoint  = aws_lambda_function.scanning_notification.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.scanning_notifications.arn
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "scanning_lambda_logging" {
  name        = "AllowScanningLambdaLogging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = file("${path.module}/policies/allow_lambda_logging.json")

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "scanning_lambda_logs" {
  role       = aws_iam_role.scanning_notification.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
