# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "pncemulator" {
  name                 = "pncemulator"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_pncemulator" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.pncemulator.name
}

resource "aws_ecr_lifecycle_policy" "pncemulator" {
  policy     = file("${path.module}/policies/helper_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.pncemulator.name
}
