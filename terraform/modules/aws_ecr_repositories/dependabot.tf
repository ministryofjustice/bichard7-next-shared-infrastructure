resource "aws_iam_user" "dependabot_user" {
  name = "github-dependabot"

  tags = var.tags
}

data "aws_iam_policy_document" "dependabot_ecr_policy" {
  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowECRRead"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "dependabot_policy" {
  name   = "DependabotECRReadAccess"
  user   = aws_iam_user.dependabot_user.name
  policy = data.aws_iam_policy_document.dependabot_ecr_policy.json
}

resource "aws_iam_access_key" "dependabot_access_key" {
  user = aws_iam_user.dependabot_user.name
}

resource "aws_ssm_parameter" "dependabot_access_key_id" {
  name  = "/dependabot/user/access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.dependabot_access_key.id

  tags = var.tags
}

resource "aws_ssm_parameter" "dependabot_secret_key" {
  name  = "/dependabot/user/secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.dependabot_access_key.secret

  tags = var.tags
}
