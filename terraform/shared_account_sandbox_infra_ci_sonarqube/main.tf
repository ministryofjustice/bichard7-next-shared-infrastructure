module "tag_vars" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "sandbox-sonarqube"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = false
    "environment-name" = "sandbox-ci"
    "account-name"     = "bichard7-sandbox-shared"
    "provisioned-by"   = "shared_account_sandbox_infra code see make shared-account-sandbox-infra-ci-sonarqube in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-infrastructure/tree/master/shared_terraform/shared_account_sandbox_infra_ci_sonarqube"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.id
  }
}

module "deploy_sonar" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/sonarqube"

  environment            = "sandbox"
  logging_bucket_name    = data.terraform_remote_state.shared_infra.outputs.s3_logging_bucket_name
  name                   = "sonarqube"
  server_certificate_arn = module.self_signed_certificate.server_certificate.arn

  tags = module.label.tags
}

module "self_signed_certificate" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/self_signed_certificate"

  tags = module.label.tags
}
