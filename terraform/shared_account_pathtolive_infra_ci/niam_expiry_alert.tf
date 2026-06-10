## SSM PARAM
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

## Codebuild - pass SSM path as env var
