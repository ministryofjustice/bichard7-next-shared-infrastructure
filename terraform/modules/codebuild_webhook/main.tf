# Requires the user running this to be an admin on the repository
resource "aws_codebuild_webhook" "trigger_build" {
  project_name = var.codebuild_project_name

  filter_group {
    # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook#filter_group
    filter {
      type    = var.filter_event_type
      pattern = var.filter_event_pattern
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.git_ref
    }

    filter {
      type    = "FILE_PATH"
      pattern = var.file_path
    }
  }
}
