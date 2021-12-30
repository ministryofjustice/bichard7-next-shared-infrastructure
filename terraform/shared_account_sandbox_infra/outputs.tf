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

output "sandbox_a_admin_arn" {
  description = "The sandbox_a Admin Assume Role ARN"
  value       = module.sandbox_a_child_access.administrator_access_role.arn
}

output "sandbox_a_ci_arn" {
  description = "The sandbox_c CI Assume Role ARN"
  value       = module.sandbox_a_child_access.ci_access_role.arn
}

output "sandbox_a_readonly_arn" {
  description = "The sandbox_a ReadOnly Assume Role ARN"
  value       = module.sandbox_a_child_access.readonly_access_role.arn
}

output "sandbox_b_admin_arn" {
  description = "The sandbox_b Admin Assume Role ARN"
  value       = module.sandbox_b_child_access.administrator_access_role.arn
}

output "sandbox_b_ci_arn" {
  description = "The sandbox_b CI Assume Role ARN"
  value       = module.sandbox_b_child_access.ci_access_role.arn
}

output "sandbox_b_readonly_arn" {
  description = "The sandbox_b ReadOnly Assume Role ARN"
  value       = module.sandbox_b_child_access.readonly_access_role.arn
}

output "sandbox_c_admin_arn" {
  description = "The sandbox_c Admin Assume Role ARN"
  value       = module.sandbox_c_child_access.administrator_access_role.arn
}

output "sandbox_c_ci_arn" {
  description = "The sandbox_c CI Assume Role ARN"
  value       = module.sandbox_c_child_access.ci_access_role.arn
}

output "sandbox_c_readonly_arn" {
  description = "The sandbox_c ReadOnly Assume Role ARN"
  value       = module.sandbox_c_child_access.readonly_access_role.arn
}

output "ci_users" {
  description = "A list of our CI users"
  value       = module.shared_account_user_access.ci_users
  sensitive   = true
}

output "parent_delegated_hosted_zone" {
  description = "Our delegated hosted zone"
  value       = aws_route53_zone.bichard7_delegated_zone
}

output "delegated_hosted_zone" {
  description = "Our dev hosted zone"
  value       = aws_route53_zone.bichard7_dev_delegated_zone
}

output "s3_logging_bucket_name" {
  description = "The name of our shared logging bucket"
  value       = module.aws_logs.aws_logs_bucket
}

output "allow_route53_assume_arn" {
  description = "The arn for the path to live assume role"
  value       = aws_iam_role.allow_pathtolive_assume.arn
}

output "shared_ci_policy_arn" {
  description = "The arn of our ci policy consumed by our codebuild jobs"
  value       = module.shared_account_user_access.ci_policy_arn
}
