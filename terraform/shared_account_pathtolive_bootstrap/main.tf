module "tag_vars" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars"
}

resource "aws_s3_account_public_access_block" "protect" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "pathtolive-bootstrap"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = true
    "environment-name" = "sharedaccount-pathtolive-bootstrap"
    "account-name"     = "bichard7-shared"
    "provisioned-by"   = "shared_account_bootstrap code see make shared_account_bootstrap in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-shared-infrastructure/tree/main/terraform/shared_account_pathtolive_bootstrap"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.name
  }
}

#set up terraform_remote_state storage/management for shared_account resources (S3/DynamoDB backend)
module "account_resources_terraform_remote_state" {
  source              = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/terraform_remote_state"
  tags                = module.label.tags
  name                = module.label.id
  bucket-object-name  = "tfstatefile"
  logging_bucket_name = module.aws_logs.aws_logs_bucket
}

module "aws_logs" {
  source            = "trussworks/logs/aws"
  version           = "~> 10.3.0 "
  s3_bucket_name    = "${module.label.id}-logging"
  force_destroy     = false
  enable_versioning = true
}
