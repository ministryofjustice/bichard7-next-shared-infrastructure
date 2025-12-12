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

variable "budget_limit_amount" {
  description = "The budget for this this account, leave blank to not create one"
  type    = string
  default = ""
}

variable "budget_notification_email_addresses" {
  description = "The email addresses to send budget alerts to"
  type = list(string)
  default = ["moj-bichard7@madetech.com"]
}
