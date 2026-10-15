output "admin_group_name" {
  description = "The name of our admin group"
  value       = module.shared_account_user_access.administrator_access_group.name
}

output "readonly_group_name" {
  description = "The name of our readonly group"
  value       = module.shared_account_user_access.readonly_access_group.name
}

output "ci_group_name" {
  description = "The name of our ci group"
  value       = module.shared_account_user_access.ci_access_group.name
}

output "mfa_group_name" {
  description = "The name of our MFA group"
  value       = module.shared_account_user_access.mfa_group.name
}

output "integration_next_admin_arn" {
  description = "The integration_next Admin Assume Role ARN"
  value       = module.integration_next_child_access.administrator_access_role.arn
}

output "integration_next_readonly_arn" {
  description = "The integration_next ReadOnly Assume Role ARN"
  value       = module.integration_next_child_access.readonly_access_role.arn
}

output "integration_next_ci_arn" {
  description = "The integration_next CI Assume Role ARN"
  value       = module.integration_next_child_access.ci_access_role.arn
}

output "integration_baseline_admin_arn" {
  description = "The integration_baseline Admin Assume Role ARN"
  value       = module.integration_baseline_child_access.administrator_access_role.arn
}

output "integration_baseline_readonly_arn" {
  description = "The integration_baseline ReadOnly Assume Role ARN"
  value       = module.integration_baseline_child_access.readonly_access_role.arn
}

output "integration_baseline_ci_arn" {
  description = "The integration_baseline CI Assume Role ARN"
  value       = module.integration_baseline_child_access.ci_access_role.arn
}

output "preprod_ci_arn" {
  description = "The preprod CI Assume Role ARN"
  value       = module.preprod_child_access.ci_access_role.arn
}

output "preprod_admin_arn" {
  description = "The preprod Admin Assume Role ARN"
  value       = module.preprod_child_access.administrator_access_role.arn
}

output "ci_users" {
  description = "A list of our CI users"
  value       = module.shared_account_user_access.ci_users
  sensitive   = true
}

output "s3_logging_bucket_name" {
  description = "The name of our shared logging bucket"
  value       = module.aws_logs.aws_logs_bucket
}

output "delegated_hosted_zone" {
  description = "Our pathtolive hosted zone"
  value       = aws_route53_zone.bichard7_pathtolive_delegated_zone
}

output "shared_ci_policy_arn" {
  description = "The arn of our ci policy consumed by our codebuild jobs"
  value       = module.shared_account_user_access.ci_policy_arn
}

output "production_ci_arn" {
  description = "The production CI Assume Role ARN"
  value       = module.production_child_access.ci_access_role.arn
}

output "production_admin_arn" {
  description = "The production Admin Assume Role ARN"
  value       = module.production_child_access.administrator_access_role.arn
}
