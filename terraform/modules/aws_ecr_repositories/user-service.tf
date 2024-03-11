# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "user_service" {
  name                 = "user-service"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_user_service" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.user_service.name
}

resource "aws_ecr_lifecycle_policy" "user_service" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.user_service.name
}
