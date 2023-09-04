data "docker_registry_image" "amazon_linux_2023" {
  name = "amazonlinux:2023"
}

# Get our image hashes
data "external" "amazon_linux_2023_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.amazon_linux_2023.name
  }
  depends_on = [docker_image.amazon_linux_2023]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "amazon_linux_2023" {
  name                 = "amazon-linux-2023"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_amazon_linux_2023" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.amazon_linux_2023.name
}

resource "aws_ecr_lifecycle_policy" "amazon_linux_2023" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.amazon_linux_2023.name
}

resource "docker_image" "amazon_linux_2023" {
  name          = data.docker_registry_image.amazon_linux_2023.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.amazon_linux_2023.sha256_digest]
}

resource "null_resource" "tag_and_push_amazon_linux_2023" {
  triggers = {
    amazon_linux_2023_hash = data.docker_registry_image.amazon_linux_2023.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.amazon_linux_2023.name} ${aws_ecr_repository.amazon_linux_2023.repository_url}:${data.external.amazon_linux_2023_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.amazon_linux_2023.repository_url};
      docker push ${aws_ecr_repository.amazon_linux_2023.repository_url}:${data.external.amazon_linux_2023_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.amazon_linux_2023]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "amazon_linux_2023_base" {
  name                 = "amazon-linux2023-base"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_amazon_linux_2023_base" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.amazon_linux_2023_base.name
}

resource "aws_ecr_lifecycle_policy" "amazon_linux_2023_base" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.amazon_linux_2023_base.name
}
