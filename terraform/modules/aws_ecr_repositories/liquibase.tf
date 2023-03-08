data "docker_registry_image" "liquibase" {
  name = "liquibase/liquibase"
}

# Get our image hashes
data "external" "liquibase_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.liquibase.name
  }
  depends_on = [docker_image.liquibase]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "liquibase" {
  name                 = "liquibase"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_liquibase" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.liquibase.name
}

resource "docker_image" "liquibase" {
  name          = data.docker_registry_image.liquibase.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.liquibase.sha256_digest]
}

resource "null_resource" "tag_and_push_liquibase" {
  triggers = {
    liquibase_hash = data.docker_registry_image.liquibase.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.liquibase.name} ${aws_ecr_repository.liquibase.repository_url}:${data.external.liquibase_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.liquibase.repository_url};
      docker push ${aws_ecr_repository.liquibase.repository_url}:${data.external.liquibase_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.liquibase]
}

resource "aws_ecr_lifecycle_policy" "liquibase" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.liquibase.name
}
