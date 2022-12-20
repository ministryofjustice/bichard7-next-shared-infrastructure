# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "ui" {
  name                 = "ui"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_ui" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.ui.name
}

resource "aws_ecr_lifecycle_policy" "ui" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.ui.name
}
