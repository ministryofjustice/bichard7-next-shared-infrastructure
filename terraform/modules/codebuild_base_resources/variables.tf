variable "tags" {
  description = "A map of resource tags"
  type        = map(string)
}

variable "name" {
  description = "Our resource name"
  type        = string
}

variable "aws_logs_bucket" {
  description = "Our account logging bucket for s3 logs"
  type        = string
}

variable "slack_webhook" {
  description = "Our webhook for slack"
  type        = string
}

variable "channel_name" {
  description = "Our slack channel for notifications"
  default     = "moj-cjse-bichard"
  type        = string
}

variable "notifications_channel_name" {
  default     = "moj-cjse-bichard-notifications"
  type        = string
  description = "Our slack channel for build notifications"
}

variable "allow_accounts" {
  description = "A list of account ids allowed to access our s3 resource"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "Our cidr block to apply to this vpc"
  type        = string
  default     = null
}

variable "codebuild_sg_environment_names" {
  description = "List of environment names for CodeBuild security groups"
  type        = set(string)
  default     = []
}

variable "is_sandbox_account" {
  description = "Is this a sandbox account?"
  type        = bool
  default     = false
}
