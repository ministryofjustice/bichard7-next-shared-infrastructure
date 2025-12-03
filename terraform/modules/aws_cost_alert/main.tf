resource "aws_cloudwatch_metric_alarm" "sandbox_cost_alert" {
  alarm_name          = "${var.account_prefix}-cost-alert"
  alarm_description   = "Billing alarm when EstimatedCharges exceed threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.threshold_usd

  metric_name = "EstimatedCharges"
  namespace   = "AWS/Billing"
  statistic   = "Maximum"
  period      = var.period_seconds

  alarm_actions      = [aws_sns_topic.sandbox_cost_topic.arn]
  treat_missing_data = "notBreaching"
}
