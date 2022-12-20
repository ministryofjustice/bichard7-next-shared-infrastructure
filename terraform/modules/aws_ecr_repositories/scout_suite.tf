data "docker_registry_image" "scoutsuite" {
  name = "rossja/ncc-scoutsuite:aws-latest"
}
# Get our image hashes
data "external" "scoutsuite_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.scoutsuite.name
  }
  depends_on = [docker_image.scoutsuite]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "scoutsuite" {
  name                 = "scoutsuite"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_scoutsuite" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.scoutsuite.name
}

resource "docker_image" "scoutsuite" {
  name          = data.docker_registry_image.scoutsuite.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.scoutsuite.sha256_digest]
}

resource "null_resource" "tag_and_push_scoutsuite" {
  triggers = {
    scoutesuite_hash = data.docker_registry_image.scoutsuite.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.scoutsuite.name} ${aws_ecr_repository.scoutsuite.repository_url}:${data.external.scoutsuite_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.scoutsuite.repository_url};
      docker push ${aws_ecr_repository.scoutsuite.repository_url}:${data.external.scoutsuite_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.scoutsuite]
}

resource "aws_ecr_lifecycle_policy" "scoutsuite" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.scoutsuite.name
}
