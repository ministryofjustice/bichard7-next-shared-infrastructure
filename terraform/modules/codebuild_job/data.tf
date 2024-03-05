data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "access_key_id" {
  name = var.aws_access_key_id_ssm_path

  with_decryption = true
}

data "aws_ssm_parameter" "secret_access_key" {
  name = var.aws_secret_access_key_ssm_path

  with_decryption = true
}

data "aws_iam_group" "ci_user_group" {
  group_name = "CIAccess"
}
