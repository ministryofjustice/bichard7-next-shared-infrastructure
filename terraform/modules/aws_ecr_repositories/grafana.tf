# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "grafana" {
  name                 = "grafana"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_grafana" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.grafana.name
}

resource "aws_ecr_lifecycle_policy" "grafana" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.grafana.name
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "grafana_codebuild" {
  name                 = "grafana-codebuild"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_grafana_codebuild" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.grafana_codebuild.name
}

resource "aws_ecr_lifecycle_policy" "grafana_codebuild" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.grafana_codebuild.name
}
