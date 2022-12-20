# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "openjdk_jre" {
  name                 = "openjdk-jre11-slim"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_openjdk_jre" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.openjdk_jre.name
}

resource "aws_ecr_lifecycle_policy" "openjdk_jre" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.openjdk_jre.name
}
