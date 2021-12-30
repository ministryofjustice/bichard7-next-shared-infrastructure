module "tag_vars" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "sandbox-ci"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = false
    "environment-name" = "sandbox-users"
    "account-name"     = "bichard7-sandbox-shared"
    "provisioned-by"   = "shared_account_sandbox_users code see make shared-account-sandbox-users in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-infrastructure/tree/master/shared_terraform/shared_account_sandbox_users"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.id
  }
}
