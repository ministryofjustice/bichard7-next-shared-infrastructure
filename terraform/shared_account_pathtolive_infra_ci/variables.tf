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

# variable "codebuild_s3_bucket" {
#   description = "The name of our codebuild bucket used for logs and artificacts"
#   type        = string
# }

# variable "sns_notifications_arn" {
#   description = "The notifications arn for SNS"
#   type        = string
# }

# variable "tags" {
#   description = "A map of tags for our infrastructure"
#   type        = map(string)
# }

# variable "notifications_kms_key_arn" {
#   description = "The arn for our notifications KMS key"
#   type        = string
# }
