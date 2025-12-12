variable "tags" {
  description = "A map of tags to apply to our shared accounts"
  default     = {}
}

variable "root_account_id" {
  type        = string
  description = "The ID of the parent account"
}

variable "account_id" {
  type        = string
  description = "The ID of the account"
}

variable "bucket_name" {
  type        = string
  description = "The name of the shared bucket"
}

variable "logging_bucket_name" {
  type        = string
  description = "The name of the shared logging bucket"
}

variable "denied_user_arns" {
  description = "A list of arns that cannot assume roles"
  type        = list(string)
  default     = []
}

variable "create_nuke_user" {
  description = "Do we want to create user to run AWS Nuke with"
  type        = bool
  default     = false
}

variable "create_budget" {
  description = "Do you want to set a budget (with a cost alert) for this account?"
  type = bool
  default = false
}

variable "budget_limit" {
  description = "What is the budget limit for the account?"
  type = string
  default = "0"
}

variable "budget_notification_email_addresses" {
  description = "The list of email addresses to notify when budget alerts are triggered"
  type = list(string)
  default = []
}
