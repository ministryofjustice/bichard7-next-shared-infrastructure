locals {
  remote_bucket_name = "cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate"

  account_ids = [
    data.aws_caller_identity.sandbox_a.account_id,
    data.aws_caller_identity.sandbox_b.account_id,
    data.aws_caller_identity.sandbox_c.account_id
  ]
  allow_route53_policy = templatefile("${path.module}/policies/route53_allow_delegated.json.tpl",
    {
      zone_id = aws_route53_zone.bichard7_delegated_zone.zone_id
    }
  )
}
