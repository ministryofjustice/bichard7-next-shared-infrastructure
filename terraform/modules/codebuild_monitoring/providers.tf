provider "grafana" {
  url  = "https://${aws_route53_record.grafana_public_record.fqdn}"
  auth = "${aws_ssm_parameter.grafana_admin_username.value}:${aws_ssm_parameter.grafana_admin_password.value}"
}
