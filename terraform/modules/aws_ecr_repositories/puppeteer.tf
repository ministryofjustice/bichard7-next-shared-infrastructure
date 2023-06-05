data "docker_registry_image" "puppeteer" {
  name = "ghcr.io/puppeteer/puppeteer"
}
# Get our image hashes
data "external" "puppeteer_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.puppeteer.name
  }
  depends_on = [docker_image.puppeteer]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "puppeteer" {
  name                 = "puppeteer"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_puppeteer" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.puppeteer.name
}

resource "docker_image" "puppeteer" {
  name = data.docker_registry_image.puppeteer.name

  pull_triggers = [data.docker_registry_image.puppeteer.sha256_digest]
}

resource "null_resource" "tag_and_push_puppeteer" {
  triggers = {
    puppeteer_hash = data.docker_registry_image.puppeteer.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.puppeteer.name} ${aws_ecr_repository.puppeteer.repository_url}:${data.external.puppeteer_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.puppeteer.repository_url};
      docker push ${aws_ecr_repository.puppeteer.repository_url}:${data.external.puppeteer_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.puppeteer]
}

resource "aws_ecr_lifecycle_policy" "puppeteer" {
  policy     = file("${path.module}/policies/application_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.puppeteer.name
}
