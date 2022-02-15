output "grafana_url" {
  description = "The url of our grafana server"
  value       = module.codebuild_monitoring.grafana_external_fqdn
}
