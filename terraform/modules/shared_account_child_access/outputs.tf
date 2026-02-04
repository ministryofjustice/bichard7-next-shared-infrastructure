output "administrator_access_role" {
  description = "The administrator access role outputs"
  value       = aws_iam_role.assume_administrator_access
}

output "readonly_access_role" {
  description = "The readonly access role outputs"
  value       = aws_iam_role.assume_readonly_access
}

output "ci_access_role" {
  description = "The ci access role outputs"
  value       = aws_iam_role.assume_ci_access
}

output "aws_nuke_access_role" {
  description = "The aws_nuke access role outputs"
  value       = aws_iam_role.assume_aws_nuke_access.*
}

output "ci_admin_access_role" {
  description = "The ci admin role outputs"
  value       = aws_iam_role.assume_ci_admin_access
}

output "aws_support_access_role" {
  description = "The aws support role outputs"
  value       = aws_iam_role.assume_aws_support_access
}
