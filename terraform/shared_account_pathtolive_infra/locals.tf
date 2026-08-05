locals {
  remote_bucket_name = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"

  account_ids = sort([
    data.aws_caller_identity.preprod.account_id,
    data.aws_caller_identity.integration_baseline.account_id,
    data.aws_caller_identity.integration_next.account_id,
    data.aws_caller_identity.production.account_id
  ])

  parent_account_id = "497078235711"
  parent_bucket_arn = "arn:aws:s3:::moj-bichard7-production-logs"
}
