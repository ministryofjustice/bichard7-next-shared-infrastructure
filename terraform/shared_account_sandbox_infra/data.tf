data "aws_region" "current_region" {
  provider = aws.sandbox_shared
}

data "aws_caller_identity" "current" {
  provider = aws.sandbox_shared
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
