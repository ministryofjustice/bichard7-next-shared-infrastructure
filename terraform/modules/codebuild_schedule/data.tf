data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "cloudwatch_event_policy" {
  template = file("${path.module}/policies/start_pipeline.json.tpl")

  vars = {
    codebuild_arn = var.codebuild_arn
  }
}
