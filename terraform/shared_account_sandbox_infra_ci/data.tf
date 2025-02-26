data "aws_region" "current_region" {
}

data "aws_caller_identity" "current" {
}

data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket         = local.remote_bucket_name
    dynamodb_table = "${local.remote_bucket_name}-lock"
    key            = "tfstatefile"
    region         = "eu-west-2"
  }
}

data "aws_caller_identity" "sandbox_a" {
  provider = aws.sandbox_a
}

data "aws_caller_identity" "sandbox_b" {
  provider = aws.sandbox_b
}

data "aws_caller_identity" "sandbox_c" {
  provider = aws.sandbox_c
}

data "aws_ecr_repository" "was" {
  name = "bichard7-liberty"
}

data "external" "latest_was_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.was.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}


data "aws_ecr_repository" "codebuild_base" {
  name = "codebuild-base"

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "external" "latest_codebuild_base" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.codebuild_base.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "aws_ecr_repository" "scoutsuite" {
  name = "scoutsuite"

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "external" "latest_scoutsuite" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.scoutsuite.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = aws_secretsmanager_secret.github_token.id
}
