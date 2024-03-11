data "aws_caller_identity" "current" {}





data "aws_ssm_parameter" "ci_user" {
  name            = "/users/system/ci"
  with_decryption = true
}

data "aws_ssm_parameter" "aws_nuke_user" {
  count           = (var.create_nuke_user == true) ? 1 : 0
  name            = "/users/system/aws_nuke"
  with_decryption = true
}


