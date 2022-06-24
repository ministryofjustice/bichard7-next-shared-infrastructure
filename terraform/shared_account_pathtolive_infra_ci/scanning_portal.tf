module "self_signed_certificate" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/self_signed_certificate"

  tags = module.label.tags
}

module "ecs_scanning_portal" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules//scanning_results_ecs"

  fargate_cpu             = 2048
  fargate_memory          = 4096
  logging_bucket_name     = module.codebuild_base_resources.codepipeline_bucket
  name                    = module.label.id
  public_zone_id          = aws_route53_zone.codebuild_public_zone.zone_id
  self_signed_certificate = module.self_signed_certificate.server_certificate
  service_subnets         = module.codebuild_base_resources.codebuild_public_subnet_ids
  ssl_certificate_arn     = aws_acm_certificate.bichard7_pathtolive_delegated_zone.arn
  vpc_id                  = module.codebuild_base_resources.codebuild_vpc_id
  scanning_bucket_name    = module.codebuild_base_resources.scanning_results_bucket
  tags                    = module.label.tags
}
