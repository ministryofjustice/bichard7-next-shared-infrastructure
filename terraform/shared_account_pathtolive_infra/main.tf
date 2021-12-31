module "tag_vars" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars"
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
    "environment-name" = "pathtolive-shared-infra"
    "account-name"     = "bichard7-shared"
    "provisioned-by"   = "shared_account_pathtolive_infra code see make shared-account-pathtolive-infra in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-shared-infrastructure/tree/master/shared_terraform/shared_account_pathtolive_infra"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.name
  }
}

module "aws_logs" {
  source            = "trussworks/logs/aws"
  version           = "~> 10.3.0 "
  s3_bucket_name    = "${module.label.name}-aws-logs"
  enable_versioning = true

  tags = module.label.tags
}

module "shared_account_user_access" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent"
  tags   = module.label.tags

  buckets = [
    "arn:aws:s3:::${local.remote_bucket_name}",
    "arn:aws:s3:::${module.aws_logs.aws_logs_bucket}"
  ]

  providers = {
    aws = aws.shared
  }
}

resource "aws_route53_zone" "bichard7_pathtolive_delegated_zone" {
  name    = "ptl.bichard7.modernisation-platform.service.justice.gov.uk"
  comment = "Delegation zone for pathtolive domains"

  lifecycle {
    prevent_destroy = true
  }

  tags = module.label.tags
}

resource "aws_route53_record" "bichard7_pathtolive_name_servers" {
  zone_id = var.parent_zone_id
  name    = aws_route53_zone.bichard7_pathtolive_delegated_zone.name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.bichard7_pathtolive_delegated_zone.name_servers

  provider = aws.sandbox
}
