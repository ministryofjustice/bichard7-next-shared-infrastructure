data "docker_registry_image" "gradle_jdk11" {
  name = "gradle:6.7-jdk11"
}
# Get our image hashes
data "external" "gradle_jdk11_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.gradle_jdk11.name
  }
  depends_on = [docker_image.gradle_jdk11]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "gradle_jdk11" {
  name                 = "gradle-jdk11"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_gradle_jdk11" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.gradle_jdk11.name
}

resource "docker_image" "gradle_jdk11" {
  name          = data.docker_registry_image.gradle_jdk11.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.gradle_jdk11.sha256_digest]
}

resource "null_resource" "tag_and_push_gradle_jdk11" {
  triggers = {
    gradle_jdk11_hash = data.docker_registry_image.gradle_jdk11.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.gradle_jdk11.name} ${aws_ecr_repository.gradle_jdk11.repository_url}:${data.external.gradle_jdk11_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.gradle_jdk11.repository_url};
      docker push ${aws_ecr_repository.gradle_jdk11.repository_url}:${data.external.gradle_jdk11_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.gradle_jdk11]
}

resource "aws_ecr_lifecycle_policy" "gradle_jdk11" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.gradle_jdk11.name
}
