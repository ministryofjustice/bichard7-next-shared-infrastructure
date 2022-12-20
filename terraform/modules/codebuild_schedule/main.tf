resource "aws_cloudwatch_event_rule" "trigger_codebuild_build" {
  name = "${var.name}-trigger"

  description         = "Automatically rebuild our ${var.name} job"
  schedule_expression = var.cron_expression
  is_enabled          = true

  tags = var.tags
}

resource "aws_iam_role" "trigger_codebuild_build_role" {
  assume_role_policy = file("${path.module}/policies/trust_policy_for_cwe.json")
  name               = "TrustPolicyForCWE-${var.name}"

  tags = var.tags
}

resource "aws_iam_role_policy" "trigger_codebuild_build_policy" {
  policy = data.template_file.cloudwatch_event_policy.rendered
  role   = aws_iam_role.trigger_codebuild_build_role.id
}

resource "aws_cloudwatch_event_target" "trigger_codebuild_build_target" {
  arn      = var.codebuild_arn
  rule     = aws_cloudwatch_event_rule.trigger_codebuild_build.name
  role_arn = aws_iam_role.trigger_codebuild_build_role.arn
}
