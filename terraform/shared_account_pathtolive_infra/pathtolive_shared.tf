module "shared_account_user_access" {
  source = "../modules/shared_account_parent"
  tags   = module.label.tags

  buckets = [
    "arn:aws:s3:::${local.remote_bucket_name}",
    "arn:aws:s3:::${module.aws_logs.aws_logs_bucket}"
  ]

  is_path_to_live = true

  providers = {
    aws = aws.shared
  }
}

import {
  to = aws_s3_bucket.csoc_logs
  id = "moj-bichard7-aws-logs"
}

import {
  to = module.shared_account_user_access.aws_s3_bucket_policy.bucket_policy
  id = "moj-bichard7-aws-logs"
}

resource "aws_s3_bucket" "csoc_logs" {
  bucket = "moj-bichard7-aws-logs"
}
