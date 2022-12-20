resource "aws_codebuild_project" "cb_project" {
  name           = var.name
  badge_enabled  = false
  build_timeout  = var.build_timeout
  description    = var.build_description
  service_role   = aws_iam_role.service_role.arn
  source_version = var.git_ref
  queued_timeout = 480

  dynamic "vpc_config" {
    for_each = var.vpc_config
    content {
      security_group_ids = lookup(vpc_config.value, "security_group_ids", [])
      subnets            = lookup(vpc_config.value, "subnets", [])
      vpc_id             = lookup(vpc_config.value, "vpc_id", null)
    }
  }

  source {
    type                = "GITHUB"
    location            = "https://github.com/ministryofjustice/${var.repository_name}.git"
    git_clone_depth     = 1
    report_build_status = var.report_build_status

    git_submodules_config {
      fetch_submodules = true
    }
    buildspec = var.buildspec_file
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  logs_config {
    s3_logs {
      encryption_disabled = false
      location            = "${var.codepipeline_s3_bucket}/${var.name}/build-log"
      status              = "ENABLED"
    }
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  dynamic "secondary_sources" {
    for_each = var.codebuild_secondary_sources
    content {
      source_identifier = secondary_sources.value.source_identifier
      type              = secondary_sources.value.type
      location          = secondary_sources.value.location
      git_clone_depth   = 1

      git_submodules_config {
        fetch_submodules = true
      }
    }
  }

  # Environment
  dynamic "environment" {
    for_each = var.build_environments
    content {
      compute_type    = environment.value.compute_type
      image           = environment.value.image
      type            = environment.value.type
      privileged_mode = environment.value.privileged_mode

      image_pull_credentials_type = lookup(environment.value, "image_pull_credentials_type", "CODEBUILD")

      dynamic "environment_variable" {
        for_each = local.environment_variables
        content {
          name  = environment_variable.value.name
          value = environment_variable.value.value
          type  = lookup(environment_variable.value, "type", null) == null ? "PLAINTEXT" : environment_variable.value.type
        }
      }
    }
  }

  tags = local.tags
}

module "codebuild_pipeline_notification" {
  # Only create codestar notifications if we have some to fire
  count = (length(var.event_type_ids) > 0) ? 1 : 0

  source = "../codestar_notification"

  ci_cd_service_role_name = aws_iam_role.service_role.name
  name                    = var.name
  notification_source_arn = aws_codebuild_project.cb_project.arn
  sns_kms_key_arn         = var.sns_kms_key_arn
  sns_notification_arn    = var.sns_notification_arn
  event_type_ids          = var.event_type_ids

  tags = local.tags
}
