data "docker_registry_image" "zap_owasp_scanner" {
  name = "softwaresecurityproject/zap-stable"
}
# Get our image hashes
data "external" "zap_owasp_scanner_hash" {
  program = ["bash", "${path.module}/scripts/docker_hash.sh"]

  query = {
    image = data.docker_registry_image.zap_owasp_scanner.name
  }
  depends_on = [docker_image.zap_owasp_scanner]
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "zap_owasp_scanner" {
  name                 = "zap-owasp-scanner"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "allow_codebuild_zap_owasp_scanner" {
  policy     = file("${path.module}/templates/codebuild_image_policy.json")
  repository = aws_ecr_repository.zap_owasp_scanner.name
}

resource "docker_image" "zap_owasp_scanner" {
  name          = data.docker_registry_image.zap_owasp_scanner.name
  keep_locally  = false
  pull_triggers = [data.docker_registry_image.zap_owasp_scanner.sha256_digest]
}

resource "null_resource" "tag_and_push_zap_owasp_scanner" {
  triggers = {
    owasp_scanner_hash = data.docker_registry_image.zap_owasp_scanner.sha256_digest
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      docker tag ${data.docker_registry_image.zap_owasp_scanner.name} ${aws_ecr_repository.zap_owasp_scanner.repository_url}:${data.external.zap_owasp_scanner_hash.result.short_hash};
      aws ecr get-login-password --region ${data.aws_region.current_region.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.zap_owasp_scanner.repository_url};
      docker push ${aws_ecr_repository.zap_owasp_scanner.repository_url}:${data.external.zap_owasp_scanner_hash.result.short_hash}
    EOF
  }
  depends_on = [docker_image.zap_owasp_scanner]
}

resource "aws_ecr_lifecycle_policy" "zap_owasp_scanner" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.zap_owasp_scanner.name
}
