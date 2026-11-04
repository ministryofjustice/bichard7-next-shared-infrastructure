# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "analytics_data_loader" {
  name                 = "analytics-data-loader"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_analytics_data_loader" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.analytics_data_loader.name
}

resource "aws_ecr_lifecycle_policy" "analytics_data_loader" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.analytics_data_loader.name
}
