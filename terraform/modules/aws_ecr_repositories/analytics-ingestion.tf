# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "analytics_ingestion" {
  name                 = "analytics-ingestion"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_analytics_ingestion" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.analytics_ingestion.name
}

resource "aws_ecr_lifecycle_policy" "analytics_ingestion" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.analytics_ingestion.name
}
