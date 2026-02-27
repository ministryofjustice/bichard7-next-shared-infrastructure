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

data "aws_s3_bucket" "csoc_logs" {
  bucket = "moj-bichard7-production-logs"
}

data "aws_iam_policy_document" "send_to_csoc_sqs" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.csoc_queue.arn]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [data.aws_s3_bucket.csoc_logs.arn]
    }
  }
}

data "aws_iam_policy_document" "csoc_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::258361008057:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["test"]
    }
  }
}
