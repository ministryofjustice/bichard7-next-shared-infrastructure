data "aws_caller_identity" "current" {}

data "template_file" "lambda_cloudtrail_policy" {
  template = file("${path.module}/policies/lambda_cloudtrail.json.tpl")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "lambda_logging_bucket" {
  template = file("${path.module}/policies/lambda_logging_bucket.json.tpl")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
    name       = var.name
  }
}
