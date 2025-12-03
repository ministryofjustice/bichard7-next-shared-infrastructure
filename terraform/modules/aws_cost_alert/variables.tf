variable "account_prefix" {
  description = "Prefix for alarm resource names"
  type        = string
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for billing alerts"
  type        = string
}

variable "threshold_usd" {
  description = "Billing alarm threshold in USD"
  type        = number
  default     = 1275
}

variable "period_seconds" {
  description = "CloudWatch alarm evaluation period"
  type        = number
  default     = 21600 # 6 hours
}
