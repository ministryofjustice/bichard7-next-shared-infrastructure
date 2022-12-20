output "slack_sns_topic" {
  description = "The slack webook sns topic"
  value       = aws_sns_topic.slack_webhook_notifications
}
