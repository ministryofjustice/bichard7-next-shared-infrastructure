output "grafana_external_fqdn" {
  description = "The public dns record for our grafana server"
  value       = aws_route53_record.grafana_public_record.fqdn
}

output "grafana_api_key" {
  description = "The api key we can use to provision grafana resources"
  sensitive   = true
  value       = grafana_api_key.admin_api_key.key
}

output "grafana_admin_user_name" {
  description = "The user name of our grafana admin"
  sensitive   = true
  value       = aws_ssm_parameter.grafana_admin_username.value
}

output "grafana_admin_user_password" {
  description = "The password of our grafana admin"
  sensitive   = true
  value       = aws_ssm_parameter.grafana_admin_password.value
}
