# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "nginx_nodejs_24_2023_supervisord" {
  name                 = "nginx-nodejs-24-2023-supervisord"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_nginx_nodejs_24_2023_supervisord" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.nginx_nodejs_24_2023_supervisord.name
}

resource "aws_ecr_lifecycle_policy" "nginx_nodejs_24_2023_supervisord" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.nginx_nodejs_24_2023_supervisord.name
}
