# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "liquibase_upstream" {
  name                 = "liquibase-upstream"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_liquibase_upstream" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.liquibase_upstream.name
}

resource "aws_ecr_lifecycle_policy" "liquibase_upstream" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.liquibase_upstream.name
}
