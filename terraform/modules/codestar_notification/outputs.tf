output "notification_rule_arn" {
  description = "The arn of our codestar notification"
  value       = aws_codestarnotifications_notification_rule.codebuild_notification_rule.arn
}
