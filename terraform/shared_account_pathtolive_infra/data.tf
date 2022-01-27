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

data "aws_ssm_parameter" "non_sc_users" {
  name = "/users/provisioned/non_sc_users"
}
