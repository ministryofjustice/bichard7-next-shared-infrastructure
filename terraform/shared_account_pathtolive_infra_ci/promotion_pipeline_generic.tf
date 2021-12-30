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


module "tag_develop_release" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description = "Tags our branches as a release"
  name              = "tag-sources-as-release"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "tag-repositories.yml"

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  event_type_ids         = []

  environment_variables = [
    {
      name  = "BRANCH"
      value = "develop"
    }
  ]
  tags = module.label.tags
}

module "tag_rc_release" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description = "Tags our branches as a release candidate"
  name              = "tag-sources-as-release-candidate-release"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "tag-repositories.yml"

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  environment_variables = [
    {
      name  = "BRANCH"
      value = "rc"
    }
  ]

  tags = module.label.tags
}

module "tag_production_release" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description = "Tags our branches as a release"
  name              = "tag-sources-as-production-release"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "tag-repositories.yml"

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn

  environment_variables = [
    {
      name  = "BRANCH"
      value = "master"
    }
  ]

  tags = module.label.tags
}
