data "aws_region" "current_region" {
}

data "aws_caller_identity" "current" {
}


data "aws_ecr_repository" "nodejs_20_2023" {
  name = "nodejs-20-2023"
}

data "aws_ecr_repository" "nodejs_24_2023" {
  name = "nodejs-24-2023"
}


data "external" "latest_nodejs_20_2023_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.nodejs_20_2023.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}

data "external" "latest_nodejs_24_2023_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.nodejs_24_2023.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}

