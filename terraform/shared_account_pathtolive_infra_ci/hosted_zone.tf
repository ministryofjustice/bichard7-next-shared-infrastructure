resource "aws_route53_zone" "codebuild_public_zone" {
  name = local.public_dns_name

  tags = module.label.tags
}

resource "aws_route53_record" "bichard7_name_servers" {
  zone_id = data.terraform_remote_state.shared_infra.outputs.delegated_hosted_zone.zone_id
  name    = aws_route53_zone.codebuild_public_zone.name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.codebuild_public_zone.name_servers
}

resource "aws_acm_certificate" "bichard7_pathtolive_delegated_zone" {
  domain_name = aws_route53_zone.codebuild_public_zone.name
  subject_alternative_names = [
    "*.${aws_route53_zone.codebuild_public_zone.name}"
  ]

  validation_method = "DNS"

  tags = module.label.tags

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  child_record  = tolist(aws_acm_certificate.bichard7_pathtolive_delegated_zone.domain_validation_options)[0]
  parent_record = tolist(aws_acm_certificate.bichard7_pathtolive_delegated_zone.domain_validation_options)[1]
}

resource "aws_route53_record" "bichard7_pathtolive_delegated_zone_validation_records" {
  allow_overwrite = true
  name            = local.child_record.resource_record_name
  records         = [local.child_record.resource_record_value]
  ttl             = 60
  type            = local.child_record.resource_record_type
  zone_id         = aws_route53_zone.codebuild_public_zone.zone_id
}

resource "aws_route53_record" "parent_zone_validation_records" {
  allow_overwrite = true
  name            = local.parent_record.resource_record_name
  records         = [local.parent_record.resource_record_value]
  ttl             = 60
  type            = local.parent_record.resource_record_type
  zone_id         = data.terraform_remote_state.shared_infra.outputs.delegated_hosted_zone.zone_id
}

# resource "aws_acm_certificate_validation" "base_infra_certificate_validation" {
#   certificate_arn = aws_acm_certificate.bichard7_pathtolive_delegated_zone.arn
# }
