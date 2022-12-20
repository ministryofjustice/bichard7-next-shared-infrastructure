data "docker_registry_image" "amazon_linux_2" {
  name = "amazonlinux:2"
}

# Get our image hashes
data "external" "amazon_linux_2_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.amazon_linux_2.name
  }
  depends_on = [docker_image.amazon_linux_2]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "amazon_linux_2" {
  name                 = "amazon-linux2"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_amazon_linux" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.amazon_linux_2.name
}

resource "aws_ecr_lifecycle_policy" "amazon_linux_2" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.amazon_linux_2.name
}

resource "docker_image" "amazon_linux_2" {
  name          = data.docker_registry_image.amazon_linux_2.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.amazon_linux_2.sha256_digest]
}

resource "null_resource" "tag_and_push_amazon_linux_2" {
  triggers = {
    amazon_linux_2_hash = data.docker_registry_image.amazon_linux_2.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.amazon_linux_2.name} ${aws_ecr_repository.amazon_linux_2.repository_url}:${data.external.amazon_linux_2_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.amazon_linux_2.repository_url};
      docker push ${aws_ecr_repository.amazon_linux_2.repository_url}:${data.external.amazon_linux_2_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.amazon_linux_2]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "amazon_linux_2_base" {
  name                 = "amazon-linux2-base"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_amazon_linux_2_base" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.amazon_linux_2_base.name
}

resource "aws_ecr_lifecycle_policy" "amazon_linux_2_base" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.amazon_linux_2_base.name
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "codebuild_base" {
  name                 = "codebuild-base"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "codebuild_base" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.codebuild_base.name
}

resource "aws_ecr_repository_policy" "allow_codebuild_codebuild_base" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.codebuild_base.name
}
