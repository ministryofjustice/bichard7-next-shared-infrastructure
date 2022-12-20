resource "aws_iam_policy" "codebuild_allow_ecr" {
  name   = "${var.name}-ecr"
  policy = data.template_file.allow_resources.rendered

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
  role   = aws_iam_role.service_role.name
  policy = data.template_file.codebuild_policy.rendered
}
