data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "public" {
  zone_id = var.public_zone_id
}

data "aws_ecr_repository" "scanning_portal" {
  name = "nginx-scan-portal"
}

data "external" "scanning_portal_latest_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.scanning_portal.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}
