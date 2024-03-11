# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "bichard7_liberty" {
  name                 = "bichard7-liberty"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "ecr_bichard_liberty_policy" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.bichard7_liberty.name
}

resource "aws_ecr_lifecycle_policy" "bichard7_liberty" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.bichard7_liberty.name
}
