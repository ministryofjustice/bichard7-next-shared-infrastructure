output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.sandbox_cost_topic.arn
}

output "alarm_name" {
  description = "CloudWatch alarm name"
  value       = aws_cloudwatch_metric_alarm.sandbox_cost_alert.alarm_name
}
