output "build_bichard7_application_name" {
  description = "The name of our bichard7 application docker image build job"
  value       = module.build_bichard7_next_docker_image.pipeline_name
}

output "build_bichard7_application_service_role_name" {
  description = "The name of our bichard7 application docker job service role"
  value       = module.build_bichard7_next_docker_image.pipeline_service_role_name
}

output "build_user_service_name" {
  description = "The name of our user-service docker image build job"
  value       = module.build_bichard7_user_service_docker_image.pipeline_name
}

output "build_user_service_service_role_name" {
  description = "The name of our build user service job service role"
  value       = module.build_bichard7_user_service_docker_image.pipeline_service_role_name
}

output "build_audit_logging_name" {
  description = "The name of our audit logging docker image build job"
  value       = module.build_audit_logging.pipeline_name
}

output "build_audit_logging_service_role_name" {
  description = "The name of our audit logging service job service role"
  value       = module.build_audit_logging.pipeline_service_role_name
}

output "build_auth_proxy_name" {
  description = "The name of our auth proxy logging docker image build job"
  value       = module.build_nginx_auth_proxy_docker_image.pipeline_name
}

output "build_auth_proxy_service_role_name" {
  description = "The name of our auth proxy service job service role"
  value       = module.build_nginx_auth_proxy_docker_image.pipeline_service_role_name
}
