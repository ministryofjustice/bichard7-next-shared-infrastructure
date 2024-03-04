# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "core_worker" {
  name                 = "core-worker"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_core_worker" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.core_worker.name
}

resource "aws_ecr_lifecycle_policy" "core_worker" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.core_worker.name
}
