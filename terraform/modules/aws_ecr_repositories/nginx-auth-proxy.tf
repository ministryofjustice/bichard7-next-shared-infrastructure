# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "nginx_auth_proxy" {
  name                 = "nginx-auth-proxy"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_nginx_auth_proxy" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.nginx_auth_proxy.name
}

resource "aws_ecr_lifecycle_policy" "nginx_auth_proxy" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.nginx_auth_proxy.name
}
