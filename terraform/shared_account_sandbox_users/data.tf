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

data "aws_iam_group" "admin_group" {
  group_name = data.terraform_remote_state.shared_infra.outputs.admin_group_name
}

data "aws_iam_group" "readonly_group" {
  group_name = data.terraform_remote_state.shared_infra.outputs.readonly_group_name
}

data "aws_iam_group" "mfa_group" {
  group_name = data.terraform_remote_state.shared_infra.outputs.mfa_group_name
}
