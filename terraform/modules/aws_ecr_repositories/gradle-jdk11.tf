# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "gradle_jdk11" {
  name                 = "gradle-jdk11"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_gradle_jdk11" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.gradle_jdk11.name
}

resource "aws_ecr_lifecycle_policy" "gradle_jdk11" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.gradle_jdk11.name
}
