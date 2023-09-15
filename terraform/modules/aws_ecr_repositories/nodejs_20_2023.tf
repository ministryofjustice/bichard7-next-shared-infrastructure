# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "nodejs_20_2023" {
  name                 = "nodejs-20-2023"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_nodejs_20_2023" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.nodejs_20_2023.name
}

resource "aws_ecr_lifecycle_policy" "nodejs_20_2023" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.nodejs_20_2023.name
}
