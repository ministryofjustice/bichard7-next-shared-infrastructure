data "docker_registry_image" "liberty" {
  name = "open-liberty:kernel-slim-java11-openj9"
}
# Get our image hashes
data "external" "liberty_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.liberty.name
  }
  depends_on = [docker_image.liberty]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "liberty" {
  name                 = "open-liberty"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_liberty" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.liberty.name
}

resource "docker_image" "liberty" {
  name          = data.docker_registry_image.liberty.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.liberty.sha256_digest]
}

resource "null_resource" "tag_and_push_liberty" {
  triggers = {
    liberty_hash = data.docker_registry_image.liberty.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.liberty.name} ${aws_ecr_repository.liberty.repository_url}:${data.external.liberty_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.liberty.repository_url};
      docker push ${aws_ecr_repository.liberty.repository_url}:${data.external.liberty_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.liberty]
}

resource "aws_ecr_lifecycle_policy" "liberty" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.liberty.name
}
