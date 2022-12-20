# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "audit_logging_portal" {
  name                 = "audit-log-portal"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_audit_logging_portal" {
  policy     = data.template_file.shared_docker_image_policy.rendered
  repository = aws_ecr_repository.audit_logging_portal.name
}

resource "aws_ecr_lifecycle_policy" "audit_logging_portal" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.audit_logging_portal.name
}
