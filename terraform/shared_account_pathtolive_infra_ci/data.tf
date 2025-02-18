data "aws_region" "current_region" {
}

data "aws_caller_identity" "current" {
}

data "aws_caller_identity" "integration_next" {
  provider = aws.integration_next
}

data "aws_caller_identity" "integration_baseline" {
  provider = aws.integration_baseline
}

data "aws_caller_identity" "preprod" {
  provider = aws.qsolution
}

data "aws_caller_identity" "production" {
  provider = aws.production
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

data "aws_ecr_repository" "bichard" {
  name = "bichard7-liberty"

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "aws_ecr_repository" "liquibase" {
  name = "liquibase"

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "external" "latest_liquibase" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.liquibase.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]

  depends_on = [
    module.codebuild_base_resources
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

data "external" "latest_codebuild_2023_base" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", module.codebuild_docker_resources.codebuild_2023_base.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]

  depends_on = [
    module.codebuild_base_resources
  ]
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = aws_secretsmanager_secret.github_token.id
}
