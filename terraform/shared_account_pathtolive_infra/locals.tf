locals {
  remote_bucket_name = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"

  account_ids = sort([
    data.aws_caller_identity.preprod.account_id,
    data.aws_caller_identity.integration_baseline.account_id,
    data.aws_caller_identity.integration_next.account_id,
    data.aws_caller_identity.production.account_id
  ])
}
