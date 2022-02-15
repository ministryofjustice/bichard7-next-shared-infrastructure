provider "aws" {}

provider "grafana" {
  url  = "https://${module.codebuild_monitoring.grafana_external_fqdn}"
  auth = "${module.codebuild_monitoring.grafana_admin_user_name}:${module.codebuild_monitoring.grafana_admin_password}"
}
