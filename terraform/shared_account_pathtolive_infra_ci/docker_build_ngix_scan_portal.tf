module "build_nginx_scan_portal" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job?ref=upgrade-aws-provider"

  name              = "build-nginx-scan-portal-docker"
  build_description = "Codebuild for Building the Scan Portal Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Scanning_Results_Portal/buildspec.yml"

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  environment_variables  = local.common_cd_vars

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}
