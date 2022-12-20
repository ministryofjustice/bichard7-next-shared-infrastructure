module "tag_vars" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

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

module "codebuild_monitoring" {
  source = "../modules/codebuild_monitoring"

  fargate_cpu            = 2048
  fargate_memory         = 4096
  logging_bucket_name    = data.terraform_remote_state.shared_infra_ci.outputs.codepipeline_bucket
  name                   = module.label.name
  public_zone_id         = data.terraform_remote_state.shared_infra_ci.outputs.codebuild_zone_id
  service_subnets        = data.terraform_remote_state.shared_infra_ci.outputs.codebuild_public_subnet_ids
  ssl_certificate_arn    = data.terraform_remote_state.shared_infra_ci.outputs.ssl_certificate_arn
  vpc_id                 = data.terraform_remote_state.shared_infra_ci.outputs.codebuild_vpc_id
  grafana_image          = "${data.aws_ecr_repository.grafana_codebuild.repository_url}@${data.external.latest_grafana_codebuild_image.result.tags}"
  private_subnets        = data.terraform_remote_state.shared_infra_ci.outputs.codebuild_subnet_ids
  grafana_repository_arn = data.aws_ecr_repository.grafana_codebuild.arn

  tags = module.label.tags
}
