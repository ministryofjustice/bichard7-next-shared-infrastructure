output "administrator_access_group" {
  description = "The name of the admin group"
  value       = aws_iam_group.administrator_access_group
}

output "ci_access_group" {
  description = "The name of the ci group"
  value       = aws_iam_group.ci_access_group
}

output "readonly_access_group" {
  description = "The name of the read-only group"
  value       = aws_iam_group.readonly_access_group
}

output "mfa_group" {
  description = "The name of the MFA group"
  value       = aws_iam_group.mfa_group
}

output "ci_users" {
  description = "A list of ci users"
  value = sort([
    aws_iam_user.ci_user.name
  ])
  sensitive = true
}

output "ci_users_arns" {
  description = "A list of ci user arns"
  value = sort([
    aws_iam_user.ci_user.arn
  ])
}

output "nuke_users_arns" {
  description = "A list of aws nuke user arns"
  value = sort(
    aws_iam_user.nuke_user.*.arn
  )
}

output "ci_policy_arn" {
  description = "The arn of our ci policy"
  value       = aws_iam_policy.ci_policy.arn
}
