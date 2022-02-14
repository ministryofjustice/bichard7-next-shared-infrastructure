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

data "terraform_remote_state" "shared_infra_ci" {
  backend = "s3"
  config = {
    bucket         = local.remote_bucket_name
    dynamodb_table = "${local.remote_bucket_name}-lock"
    key            = "ci/tfstatefile"
    region         = "eu-west-2"
  }
}


data "aws_ecr_repository" "grafana_codebuild" {
  name = "grafana_codebuild"
}

data "external" "latest_grafana_codebuild_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.grafana_codebuild.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}
