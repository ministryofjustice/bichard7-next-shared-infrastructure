# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "puppeteer" {
  name                 = "puppeteer"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_puppeteer" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.puppeteer.name
}

resource "aws_ecr_lifecycle_policy" "puppeteer" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.puppeteer.name
}
