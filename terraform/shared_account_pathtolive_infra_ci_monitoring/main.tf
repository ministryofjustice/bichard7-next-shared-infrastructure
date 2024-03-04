module "tag_vars" {
  source = "../modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "pathtolive-ci-monitoring"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = false
    "environment-name" = "pathtolive-ci-monitoring"
    "account-name"     = "bichard7-shared"
    "provisioned-by"   = "shared_account_sandbox_infra code see make shared-account-pathtolive-infra-ci-monitoring in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-shared-infrastructure/tree/main/shared_terraform/shared_account_pathtolive_ci_monitoring"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.id
  }
}
