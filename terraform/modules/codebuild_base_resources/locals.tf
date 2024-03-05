locals {
    allow_codestar_kms_policy = templatefile("${path.module}/policies/allow_codestar_kms.json.tpl", {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })
}
