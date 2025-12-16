variable "slack_webhook" {
  description = "Our webhook for sending messages to slack"
  type        = string
  default     = ""
}

variable "is_cd" {
  description = "Is this being run by CD"
  type        = bool
  default     = false
}

variable "deployment_reminder_limit" {
  description = "Deplyment overdue limit in days"
  type        = string
  default     = "0"
}
