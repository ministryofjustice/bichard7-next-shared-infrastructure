resource "aws_iam_policy" "codebuild_allow_ecr" {
  name = "${var.name}-ecr"
  policy = templatefile("${path.module}/policies/allow_ecr.json.tpl", {
    allowed_resources = jsonencode(local.allowed_resources)
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "codebuild_allow_ecr" {
  policy_arn = aws_iam_policy.codebuild_allow_ecr.arn
  role       = aws_iam_role.service_role.name
}

## Codebuild Service Role
resource "aws_iam_role" "service_role" {
  name               = "${var.name}-service-role"
  assume_role_policy = file("${path.module}/policies/assume_role.json")

  tags = local.tags
}

resource "aws_iam_role_policy" "codebuild_role_extra_policies" {
  role = aws_iam_role.service_role.name
  policy = templatefile("${path.module}/policies/codebuild_policy.json.tpl", {
    codebuild_bucket = "arn:aws:s3:::${var.codepipeline_s3_bucket}"
    codebuild_logs = jsonencode([
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.name}:*"
    ])
  })
}
