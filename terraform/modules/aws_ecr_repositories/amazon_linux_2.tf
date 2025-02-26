# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "amazon_linux_2" {
  name                 = "amazon-linux2"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_amazon_linux" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.amazon_linux_2.name
}

resource "aws_ecr_lifecycle_policy" "amazon_linux_2" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.amazon_linux_2.name
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "amazon_linux_2_base" {
  name                 = "amazon-linux2-base"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_amazon_linux_2_base" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.amazon_linux_2_base.name
}

resource "aws_ecr_lifecycle_policy" "amazon_linux_2_base" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.amazon_linux_2_base.name
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "codebuild_base" {
  name                 = "codebuild-base"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "codebuild_base" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.codebuild_base.name
}

resource "aws_ecr_repository_policy" "allow_codebuild_codebuild_base" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.codebuild_base.name
}
