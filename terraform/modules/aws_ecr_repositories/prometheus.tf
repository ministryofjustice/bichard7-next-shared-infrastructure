# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "prometheus" {
  name                 = "prometheus"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "prometheus_cloudwatch_exporter" {
  name                 = "prometheus-cloudwatch-exporter"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}


resource "aws_ecr_repository_policy" "ecr_prometheus_policy" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.prometheus.name
}

resource "aws_ecr_repository_policy" "ecr_prometheus_cloudwatch_exporter_policy" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.prometheus_cloudwatch_exporter.name
}

resource "aws_ecr_lifecycle_policy" "prometheus" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.prometheus.name
}
