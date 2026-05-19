resource "aws_iam_user" "dependabot_user" {
  name = "github-dependabot"

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "dependabot_public_policy_attachment" {
  user       = aws_iam_user.dependabot_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
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
