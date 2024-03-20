# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "nginx_nodejs_supervisord" {
  name                 = "nginx-nodejs-supervisord"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}


# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "nginx_java_supervisord" {
  name                 = "nginx-java-supervisord"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "nginx_supervisord" {
  name                 = "nginx-supervisord"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_nginx_java_supervisord" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.nginx_java_supervisord.name
}

resource "aws_ecr_lifecycle_policy" "nginx_java_supervisord" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.nginx_java_supervisord.name
}

resource "aws_ecr_repository_policy" "allow_codebuild_nginx_nodejs_supervisord" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.nginx_nodejs_supervisord.name
}

resource "aws_ecr_lifecycle_policy" "nginx_node_js_supervisord" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.nginx_nodejs_supervisord.name
}

resource "aws_ecr_repository_policy" "allow_codebuild_nginx_supervisord" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.nginx_supervisord.name
}

resource "aws_ecr_lifecycle_policy" "nginx_supervisord" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.nginx_supervisord.name
}
