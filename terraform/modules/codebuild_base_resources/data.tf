data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "allow_sns_publish_policy" {
  template = file("${path.module}/policies/allow_sns_policy.json.tpl")

  vars = {
    sns_topic_arn = aws_sns_topic.build_notifications.arn
    account_id    = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "allow_scanning_sns_publish_policy" {
  template = file("${path.module}/policies/allow_sns_policy.json.tpl")

  vars = {
    sns_topic_arn = aws_sns_topic.scanning_notifications.arn
    account_id    = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "allow_codestar_kms" {
  template = file("${path.module}/policies/allow_codestar_kms.json.tpl")

  vars = {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  }
}

data "aws_ssm_parameter" "slack_webhook" {
  name            = aws_ssm_parameter.slack_webhook.name
  with_decryption = true
}

data "template_file" "webhook_source" {
  template = file("${path.module}/source/webhook.py.tpl")

  vars = {
    webhook_url  = data.aws_ssm_parameter.slack_webhook.value
    channel_name = var.notifications_channel_name
  }
}

data "template_file" "scanning_webhook_source" {
  template = file("${path.module}/source/scanning_webhook.py.tpl")

  vars = {
    webhook_url  = data.aws_ssm_parameter.slack_webhook.value
    channel_name = var.notifications_channel_name
  }
}

data "template_file" "child_accounts_cmk_access_template" {
  template = file("${path.module}/policies/child_accounts_cmk_access.json.tpl")

  vars = {
    child_accounts = jsonencode(var.allow_accounts)
    account_id     = data.aws_caller_identity.current.account_id
  }
}

#tfsec:ignore:aws-iam-no-user-attached-policies
data "aws_iam_user" "ci_user" {
  user_name = "cjse.ci"
}

data "template_file" "allow_ci_slack_ssm" {
  template = file("${path.module}/policies/allow_ci_ssm.json.tpl")

  vars = {
    slack_webhook_arn = aws_ssm_parameter.slack_webhook.arn
  }
}

data "template_file" "codebuild_bucket_policy" {
  template = file("${path.module}/policies/codebuild_bucket_policy.json.tpl")

  vars = {
    bucket_arn = aws_s3_bucket.codebuild_artifact_bucket.arn
    account_id = data.aws_caller_identity.current.account_id
    allowed_principals = jsonencode(
      sort(
        concat(
          formatlist("arn:aws:iam::%s:root", var.allow_accounts),
          formatlist("arn:aws:iam::%s:role/update-environment-ssm-params-service-role", data.aws_caller_identity.current.account_id),
          formatlist("arn:aws:iam::%s:role/Bichard7-CI-Access", local.child_accounts)
        )
      )
    )
    allowed_principals_with_lambda = jsonencode(
      sort(
        concat(
          formatlist("arn:aws:iam::%s:role/portal-host-lambda-role", local.child_accounts),
          formatlist("arn:aws:iam::%s:role/Bichard7-CI-Access", local.child_accounts)
        )
      )
    )
    ci_user_arn = data.aws_iam_user.ci_user.arn
  }
}

data "template_file" "allow_dynamodb_lock_table_access" {
  template = file("${path.module}/policies/allow_dynamodb_lock_table_access.json.tpl")

  vars = {
    lock_table_arn = aws_dynamodb_table.codebuild_lock_table.arn
  }
}

data "template_file" "allow_access_to_scanning_results_bucket" {
  template = file("${path.module}/policies/allow_access_to_scanning_results_bucket.json.tpl")

  vars = {
    scanning_bucket_arn  = aws_s3_bucket.scanning_results_bucket.arn
    allowed_account_arns = jsonencode(sort(formatlist("arn:aws:iam::%s:root", var.allow_accounts)))
    account_id           = data.aws_caller_identity.current.account_id
    ci_user_arn          = data.aws_iam_user.ci_user.arn
  }
}

data "template_file" "codebuild_flow_logs_bucket" {
  template = file("${path.module}/policies/codebuild_flow_logs_bucket.json.tpl")

  vars = {
    codebuild_flow_logs_bucket_arn = aws_s3_bucket.codebuild_flow_logs_bucket.arn
  }
}

# Lambdas
data "archive_file" "codebuild_notification" {
  output_path = "/tmp/codebuild_notification_rule.zip"
  type        = "zip"

  source {
    content  = data.template_file.webhook_source.rendered
    filename = "webhook.py"
  }
}

data "archive_file" "scanning_notification" {
  output_path = "/tmp/scanning_notification_rule.zip"
  type        = "zip"

  source {
    content  = data.template_file.scanning_webhook_source.rendered
    filename = "webhook.py"
  }
}
