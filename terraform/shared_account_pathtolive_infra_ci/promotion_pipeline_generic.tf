resource "aws_kms_key" "codepipeline_deploy_key" {
  deletion_window_in_days = 14
  enable_key_rotation     = true

  policy = data.template_file.kms_permissions.rendered
  tags   = module.label.tags
}

resource "aws_kms_alias" "codepipeline_deploy_key" {
  name          = "alias/codepipeline-key"
  target_key_id = aws_kms_key.codepipeline_deploy_key.id
}

resource "aws_codestarconnections_connection" "github" {
  name          = "codepipeline-github-connection"
  provider_type = "GitHub"

  tags = module.label.tags
}
