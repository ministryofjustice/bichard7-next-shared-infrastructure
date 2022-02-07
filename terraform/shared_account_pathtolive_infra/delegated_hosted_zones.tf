## Created our delegated hosted zone
resource "aws_route53_zone" "bichard7_pathtolive_delegated_zone" {
  name    = "ptl.bichard7.modernisation-platform.service.justice.gov.uk"
  comment = "Delegation zone for pathtolive domains"

  lifecycle {
    prevent_destroy = true
  }

  tags = module.label.tags
}

# Configures our name servers
resource "aws_route53_record" "bichard7_pathtolive_name_servers" {
  zone_id = var.parent_zone_id
  name    = aws_route53_zone.bichard7_pathtolive_delegated_zone.name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.bichard7_pathtolive_delegated_zone.name_servers

  provider = aws.sandbox
}
