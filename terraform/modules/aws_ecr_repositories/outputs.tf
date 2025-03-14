output "gradle_jdk11_repository_url" {
  description = "The repository url for our gradle_jdk11 image"
  value       = aws_ecr_repository.gradle_jdk11.repository_url
}

output "gradle_jdk11_repository_arn" {
  description = "The repository arn for our gradle_jdk11 image"
  value       = aws_ecr_repository.gradle_jdk11.arn
}

output "scoutsuite_repository_url" {
  description = "The repository url for our scoutsuite image"
  value       = aws_ecr_repository.scoutsuite.repository_url
}

output "scoutsuite_repository_arn" {
  description = "The repository arn for our scoutsuite image"
  value       = aws_ecr_repository.scoutsuite.arn
}

output "zap_owasp_scanner_repository_url" {
  description = "The repository url for our zap owasp scanner image"
  value       = aws_ecr_repository.zap_owasp_scanner.repository_url
}

output "zap_owasp_scanner_repository_arn" {
  description = "The repository arn for our zap owasp scanner image"
  value       = aws_ecr_repository.zap_owasp_scanner.arn
}

output "amazon_linux_2_repository_url" {
  description = "The repository url for our amazonlinux 2 image"
  value       = aws_ecr_repository.amazon_linux_2.repository_url
}

output "amazon_linux_2_repository_arn" {
  description = "The repository arn for our amazonlinux 2 image"
  value       = aws_ecr_repository.amazon_linux_2.arn
}

output "api_repository_arn" {
  description = "The repository arn for our API image"
  value       = aws_ecr_repository.api.arn
}

output "api_repository" {
  description = "The outputs of the API ecr repository"
  value       = aws_ecr_repository.api
}

output "liquibase_repository_arn" {
  description = "The repository arn for our liquibase image"
  value       = aws_ecr_repository.liquibase.arn
}

output "puppeteer_repository_arn" {
  description = "The repository arn for our puppeteer image"
  value       = aws_ecr_repository.puppeteer.arn
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

output "nginx_auth_proxy_arn" {
  description = "The repository ARN for our nginx-auth-proxy image"
  value       = aws_ecr_repository.nginx_auth_proxy.arn
}

output "nginx_auth_proxy" {
  description = "The outputs for our nginx-auth-proxy image repository"
  value       = aws_ecr_repository.nginx_auth_proxy
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

output "codebuild_2023_base" {
  description = "The ecr repository for our codebuild 2023 image"
  value       = aws_ecr_repository.codebuild_2023_base
}
