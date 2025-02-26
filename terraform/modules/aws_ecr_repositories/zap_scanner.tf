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

resource "aws_ecr_lifecycle_policy" "zap_owasp_scanner" {
  policy     = file("${path.module}/policies/builder_image_ecr_lifecycle_policy.json")
  repository = aws_ecr_repository.zap_owasp_scanner.name
}
