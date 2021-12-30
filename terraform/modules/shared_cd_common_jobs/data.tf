data "aws_region" "current_region" {
}

data "aws_caller_identity" "current" {
}


data "aws_ecr_repository" "nodejs" {
  name = "nodejs"
}

data "external" "latest_nodejs_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.nodejs.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}
