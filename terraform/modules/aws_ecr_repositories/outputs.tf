output "gradle_jdk11_repository_url" {
  description = "The repository url for our gradle_jdk11 image"
  value       = aws_ecr_repository.gradle_jdk11.repository_url
}

output "gradle_jdk11_repository_arn" {
  description = "The repository arn for our gradle_jdk11 image"
  value       = aws_ecr_repository.gradle_jdk11.arn
}

output "gradle_jdk11_docker_image" {
  description = "The image hash for our ecs deployment"
  value       = "${aws_ecr_repository.gradle_jdk11.repository_url}@${data.docker_registry_image.gradle_jdk11.sha256_digest}"
}

output "scoutsuite_repository_url" {
  description = "The repository url for our scoutsuite image"
  value       = aws_ecr_repository.scoutsuite.repository_url
}

output "scoutsuite_repository_arn" {
  description = "The repository arn for our scoutsuite image"
  value       = aws_ecr_repository.scoutsuite.arn
}

output "scoutsuite_docker_image" {
  description = "The image hash for our ecs deployment"
  value       = "${aws_ecr_repository.scoutsuite.repository_url}@${data.docker_registry_image.scoutsuite.sha256_digest}"
}

output "openjdk_jre_repository_url" {
  description = "The repository url for our openjdk jre image"
  value       = aws_ecr_repository.openjdk_jre.repository_url
}

output "openjdk_jre_repository_arn" {
  description = "The repository arn for our openjdk jre image"
  value       = aws_ecr_repository.openjdk_jre.arn
}

output "zap_owasp_scanner_repository_url" {
  description = "The repository url for our zap owasp scanner image"
  value       = aws_ecr_repository.zap_owasp_scanner.repository_url
}

output "zap_owasp_scanner_repository_arn" {
  description = "The repository arn for our zap owasp scanner image"
  value       = aws_ecr_repository.zap_owasp_scanner.arn
}

output "zap_owasp_scanner_docker_image" {
  description = "The image hash for our ecs deployment"
  value       = "${aws_ecr_repository.zap_owasp_scanner.repository_url}@${data.docker_registry_image.zap_owasp_scanner.sha256_digest}"
}

output "amazon_linux_2_repository_url" {
  description = "The repository url for our amazonlinux 2 image"
  value       = aws_ecr_repository.amazon_linux_2.repository_url
}

output "amazon_linux_2_repository_arn" {
  description = "The repository arn for our amazonlinux 2 image"
  value       = aws_ecr_repository.amazon_linux_2.arn
}

output "amazon_linux_2_docker_image" {
  description = "The image hash for our ecs deployment"
  value       = "${aws_ecr_repository.amazon_linux_2.repository_url}@${data.docker_registry_image.amazon_linux_2.sha256_digest}"
}

output "api_repository_arn" {
  description = "The repository arn for our API image"
  value       = aws_ecr_repository.api.arn
}

output "api_repository" {
  description = "The outputs of the API ecr repository"
  value       = aws_ecr_repository.api
}

output "liquibase_docker_image" {
  description = "The image hash for liquibase"
  value       = "${aws_ecr_repository.liquibase.repository_url}@${data.docker_registry_image.liquibase.sha256_digest}"
}

output "liquibase_repository_arn" {
  description = "The repository arn for our liquibase image"
  value       = aws_ecr_repository.liquibase.arn
}

output "nodejs_repository_arn" {
  description = "The repository arn for our nodejs image"
  value       = aws_ecr_repository.nodejs.arn
}

output "puppeteer_docker_image" {
  description = "The image hash for puppeteer"
  value       = "${aws_ecr_repository.puppeteer.repository_url}@${data.docker_registry_image.puppeteer.sha256_digest}"
}

output "puppeteer_repository_arn" {
  description = "The repository arn for our puppeteer image"
  value       = aws_ecr_repository.puppeteer.arn
}

output "nginx_scan_portal_repository_arn" {
  description = "The repository arn for our nginx scan portal image"
  value       = aws_ecr_repository.nginx_scan_portal.arn
}

output "user_service_repository_arn" {
  description = "The repository arn for our user service image"
  value       = aws_ecr_repository.user_service.arn
}

output "user_service_repository" {
  description = "The outputs of the user service ecr repository"
  value       = aws_ecr_repository.user_service
}

output "ui_repository_arn" {
  description = "The repository arn for our ui image"
  value       = aws_ecr_repository.ui.arn
}

output "ui_repository" {
  description = "The outputs of the ui ecr repository"
  value       = aws_ecr_repository.ui
}

output "audit_logging_portal_arn" {
  description = "The repository arn for our audit logging portal image"
  value       = aws_ecr_repository.audit_logging_portal.arn
}

output "audit_logging_portal" {
  description = "The outputs of the audit logging portal ecr repository"
  value       = aws_ecr_repository.audit_logging_portal
}

output "grafana_repository_arn" {
  description = "The arn of our grafana repository"
  value       = aws_ecr_repository.grafana.arn
}

output "logstash_repository_arn" {
  description = "The arn of our logstash repsitory"
  value       = aws_ecr_repository.logstash_7_10_1_staged.arn
}

output "amazon_linux_2_base_arn" {
  description = "The repository arn for amazon-linux2-base image"
  value       = aws_ecr_repository.amazon_linux_2_base.arn
}

output "nginx_java_supervisord_arn" {
  description = "The repository arn for our nginx jre11 supervisord image"
  value       = aws_ecr_repository.nginx_java_supervisord.arn
}

output "nginx_nodejs_supervisord_arn" {
  description = "The repository arn for our nginx nodejs16 supervisord image"
  value       = aws_ecr_repository.nginx_nodejs_supervisord.arn
}

output "prometheus_blackbox_exporter_arn" {
  description = "The repository arn for our blackbox exporter image"
  value       = aws_ecr_repository.prometheus_blackbox_exporter.arn
}

output "nginx_supervisord_arn" {
  description = "The repository ARN for our nginx-supervisord image"
  value       = aws_ecr_repository.nginx_supervisord.arn
}

output "nginx_auth_proxy_arn" {
  description = "The repository ARN for our nginx-auth-proxy image"
  value       = aws_ecr_repository.nginx_auth_proxy.arn
}

output "nginx_auth_proxy" {
  description = "The outputs for our nginx-auth-proxy image repository"
  value       = aws_ecr_repository.nginx_auth_proxy
}

output "prometheus_repository_url" {
  description = "The repository url for our prometheus image"
  value       = aws_ecr_repository.prometheus.repository_url
}

output "prometheus_repository_arn" {
  description = "The repository arn for our prometheus image"
  value       = aws_ecr_repository.prometheus.arn
}

output "prometheus_cloudwatch_exporter_repository_url" {
  description = "The repository url for our prometheus cloudwatch exporter image"
  value       = aws_ecr_repository.prometheus_cloudwatch_exporter.repository_url
}

output "prometheus_cloudwatch_exporter_repository_arn" {
  description = "The repository arn for our prometheus cloudwatch exporter image"
  value       = aws_ecr_repository.prometheus_cloudwatch_exporter.arn
}

output "bichard_liberty_ecr" {
  description = "The Bichard Liberty ecr repository details"
  value       = aws_ecr_repository.bichard7_liberty
}

output "s3_web_proxy_ecr" {
  description = "The S3 Web Proxy ecr repository details"
  value       = aws_ecr_repository.s3_web_proxy
}

output "postfix_ecr" {
  description = "The Postfix ECR repository details"
  value       = aws_ecr_repository.postfix
}

output "codebuild_base" {
  description = "The ecr repository for our codebuild image"
  value       = aws_ecr_repository.codebuild_base
}
