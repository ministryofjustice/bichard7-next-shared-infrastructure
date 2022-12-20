data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "access_key_id" {
  name = var.aws_access_key_id_ssm_path

  with_decryption = true
}

data "aws_ssm_parameter" "secret_access_key" {
  name = var.aws_secret_access_key_ssm_path

  with_decryption = true
}

data "aws_iam_group" "ci_user_group" {
  group_name = "CIAccess"
}

data "template_file" "allow_resources" {
  template = file("${path.module}/policies/allow_ecr.json.tpl")

  vars = {
    allowed_resources = jsonencode(local.allowed_resources)
  }
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/policies/codebuild_policy.json.tpl")

  vars = {
    codebuild_bucket = "arn:aws:s3:::${var.codepipeline_s3_bucket}"
    codebuild_logs = jsonencode([
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.name}:*"
    ])
  }
}
