data "aws_region" "current_region" {
  provider = aws.shared
}

data "aws_caller_identity" "current" {
  provider = aws.shared
}

data "aws_caller_identity" "integration_next" {
  provider = aws.integration_next
}

data "aws_caller_identity" "integration_baseline" {
  provider = aws.integration_baseline
}

data "aws_caller_identity" "preprod" {
  provider = aws.preprod
}

data "aws_caller_identity" "production" {
  provider = aws.production
}

data "terraform_remote_state" "path_to_live_users" {
  backend = "s3"
  config = {
    bucket         = local.remote_bucket_name
    dynamodb_table = "${local.remote_bucket_name}-lock"
    key            = "users/tfstatefile"
    region         = "eu-west-2"
  }
}
