resource "aws_route53_zone" "bichard7_delegated_zone" {
  name    = "bichard7.modernisation-platform.service.justice.gov.uk"
  comment = "Delegation zone for dev domains"

  lifecycle {
    prevent_destroy = true
  }

  tags = module.label.tags
}

resource "aws_route53_zone" "bichard7_dev_delegated_zone" {
  name    = "dev.bichard7.modernisation-platform.service.justice.gov.uk"
  comment = "Delegation zone for dev domains"

  lifecycle {
    prevent_destroy = true
  }

  tags = module.label.tags
}

resource "aws_route53_record" "bichard7_dev_name_servers" {
  zone_id = aws_route53_zone.bichard7_delegated_zone.zone_id
  name    = aws_route53_zone.bichard7_dev_delegated_zone.name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.bichard7_dev_delegated_zone.name_servers
}

resource "aws_iam_role" "allow_pathtolive_assume" {
  assume_role_policy   = file("${path.module}/policies/allow_pathtolive_assume_role.json")
  name                 = "AllowPathToLiveAssumeRole"
  max_session_duration = 10800

  tags = module.label.tags
}

data "template_file" "allow_route53" {
  template = file("${path.module}/policies/route53_allow_delegated.json.tpl")

  vars = {
    zone_id = aws_route53_zone.bichard7_delegated_zone.zone_id
  }
}

resource "aws_iam_policy" "allow_route53" {
  policy = data.template_file.allow_route53.rendered
  name   = "AllowPathToLiveRoute53"
}

resource "aws_iam_role_policy_attachment" "allow_pathtolive_assume_route53" {
  policy_arn = aws_iam_policy.allow_route53.arn
  role       = aws_iam_role.allow_pathtolive_assume.name
}
