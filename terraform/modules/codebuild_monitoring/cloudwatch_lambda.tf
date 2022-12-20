resource "aws_iam_role" "codebuild_metrics_lambda" {
  name               = "${var.name}-codebuild-metrics-lambda"
  assume_role_policy = file("${path.module}/policies/lambda_assume_role.json")

  tags = var.tags
}

resource "aws_iam_role_policy" "codebuild_metrics_lambda" {
  name   = "${var.name}-codebuild-metrics-lambda-permissions"
  role   = aws_iam_role.codebuild_metrics_lambda.name
  policy = data.template_file.codebuild_metrics_permissions.rendered
}

#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "codebuild_metrics_lambda" {
  function_name = "${var.name}-generate-codebuild-metrics"
  description   = "Periodically Generate Custom Codebuild Metrics and push these to Cloudwatch"

  filename         = data.archive_file.codebuild_metrics_payload.output_path
  source_code_hash = data.archive_file.codebuild_metrics_payload.output_base64sha256
  handler          = "webhook.lambda_handler"

  role        = aws_iam_role.codebuild_metrics_lambda.arn
  memory_size = "128"
  runtime     = "python3.8"
  timeout     = "60"

  tracing_config {
    mode = "PassThrough"
  }

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "codebuild_metrics_lambda" {
  name                = "${var.name}-generate-codebuild-metrics"
  description         = "Scrapes job metrics once per minite"
  schedule_expression = "rate(1 minute)"

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "codebuild_metrics_lambda" {
  rule      = aws_cloudwatch_event_rule.codebuild_metrics_lambda.name
  target_id = "lambda"
  arn       = aws_lambda_function.codebuild_metrics_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codebuild_metrics_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.codebuild_metrics_lambda.arn
}
