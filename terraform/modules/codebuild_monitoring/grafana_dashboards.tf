resource "grafana_dashboard" "codebuild_dashboard" {
  config_json = file("${path.module}/dashboards/aws-codebuild_rev4.json")
}

resource "grafana_dashboard" "codebuild_status_dashboard" {
  config_json = file("${path.module}/dashboards/codebuild-pass-fail-status.json")
}

resource "grafana_dashboard" "codebuild_ecs_stats" {
  config_json = file("${path.module}/dashboards/aws-ecs_rev7.json")
}

resource "grafana_dashboard" "codebuild_last_build_status_dashboard" {
  config_json = file("${path.module}/dashboards/build_status.json")
}
