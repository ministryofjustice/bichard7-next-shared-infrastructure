# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "e2etests" {
  name                 = "e2etests"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_e2etests" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.e2etests.name
}

resource "aws_ecr_lifecycle_policy" "e2etests" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.e2etests.name
}
