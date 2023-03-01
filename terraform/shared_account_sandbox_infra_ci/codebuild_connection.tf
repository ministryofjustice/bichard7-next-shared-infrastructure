resource "aws_kms_key" "codebuild_github_auth" {
  description             = "codebuild-github-auth"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = module.label.tags
}

resource "aws_kms_alias" "codebuild_github_auth_alias" {
  target_key_id = aws_kms_key.codebuild_github_auth.id
  name          = "alias/codebuild-github-auth"
}

resource "aws_secretsmanager_secret" "github_token" {
  name       = "bichard7-github-access-token"
  kms_key_id = aws_kms_alias.codebuild_github_auth_alias.arn
}

resource "aws_codebuild_source_credential" "github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_secretsmanager_secret_version.github_token.secret_string
}
