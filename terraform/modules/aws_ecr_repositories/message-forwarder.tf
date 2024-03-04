# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "message_forwarder" {
  name                 = "message-forwarder"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_message_forwarder" {
  policy     = local.shared_docker_image_policy
  repository = aws_ecr_repository.message_forwarder.name
}

resource "aws_ecr_lifecycle_policy" "message_forwarder" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.message_forwarder.name
}
