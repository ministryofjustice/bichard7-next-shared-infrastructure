# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "s3_web_proxy" {
  name                 = "s3-web-proxy"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_s3_web_proxy" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.s3_web_proxy.name
}

resource "aws_ecr_lifecycle_policy" "s3_web_proxy" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.s3_web_proxy.name
}
