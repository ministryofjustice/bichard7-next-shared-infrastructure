# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "lambda_num_of_repos_manage_ec2_network_interfaces" {
  name = "bichard-7-${terraform.workspace}-num-of-repos-lambda-manage-ec2-network-interfaces"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })

  tags = module.label.tags
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "lambda_allow_to_list_images" {
  name = "bichard-7-${terraform.workspace}-list-images"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:ListImages",
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })

  tags = module.label.tags
}


resource "aws_iam_role" "ecr_repo_images" {
  name               = "bichard-7-${terraform.workspace}-allow-query_num_of_images"
  assume_role_policy = file("${path.module}/policies/allow_lambda_query.json")

  managed_policy_arns = [aws_iam_policy.lambda_num_of_repos_manage_ec2_network_interfaces.arn, aws_iam_policy.lambda_allow_to_list_images.arn, "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  tags                = module.label.tags
}

resource "aws_security_group" "slack_lambda_access_to_vpc" {
  name        = "slack-lambda-to-vpc"
  description = "A Security Group for the resource to VPC"
  vpc_id      = data.terraform_remote_state.shared_infra_ci.outputs.codebuild_vpc_id

  tags = merge(module.label.tags, { Name = "slack-lambda-to-vpc" })
}

resource "aws_security_group_rule" "resource_to_vpc_egress" {
  description = "Allow traffic from the resource to the VPC"

  security_group_id = aws_security_group.slack_lambda_access_to_vpc.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443

  cidr_blocks = [data.terraform_remote_state.shared_infra_ci.outputs.codebuild_cidr_block]
}

# tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "query_images_fn" {
  function_name = "${terraform.workspace}-query-ecr-images"
  description   = "Query the number of images in an ecr repo"

  filename         = data.archive_file.query_num_of_repo_images.output_path
  source_code_hash = data.archive_file.query_num_of_repo_images.output_base64sha256
  handler          = "query_number_of_repo_images.lambda_handler"

  vpc_config {
    subnet_ids         = data.terraform_remote_state.shared_infra_ci.outputs.codebuild_subnet_ids
    security_group_ids = [aws_security_group.slack_lambda_access_to_vpc.id]
  }

  role        = aws_iam_role.ecr_repo_images.arn
  memory_size = "128"
  runtime     = "python3.8"
  timeout     = "5"

  tags = module.label.tags
}

resource "aws_cloudwatch_event_rule" "query_ecr_images_cron_schedule" {
  name                = "query-ecr-images-cron-schedule"
  description         = "Fires every hour"
  schedule_expression = "cron(00 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "query_ecr_images_every_hour" {
  rule      = aws_cloudwatch_event_rule.query_ecr_images_cron_schedule.name
  target_id = "lambda"
  arn       = aws_lambda_function.query_images_fn.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_query_ecr_repo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.query_images_fn.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.query_ecr_images_cron_schedule.arn
}

resource "aws_cloudwatch_metric_alarm" "query_ecr_repo_images" {
  alarm_name        = "Query number of images in repo under threshold for ${terraform.workspace}"
  alarm_description = "There no images in ${terraform.workspace}, check the 'query-ecr-images' lambda logs for more details"

  evaluation_periods  = 5
  datapoints_to_alarm = 1
  period              = 60
  threshold           = 1
  treat_missing_data  = "ignore"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  alarm_actions = [
    module.lambda_slack_webhook.slack_sns_topic[0].arn
  ]
  ok_actions = [
    module.lambda_slack_webhook.slack_sns_topic[0].arn
  ]

  actions_enabled = true

  dimensions = {
    FunctionName = aws_lambda_function.query_images_fn.function_name
  }
  tags = module.label.tags
}
