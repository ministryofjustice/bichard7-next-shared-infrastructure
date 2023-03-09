variable "integration_next_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for integration_next"
}

variable "integration_next_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for integration_next"
}

variable "integration_next_session_token" {
  type        = string
  description = "the AWS_SESSION_TOKEN for integration_next"
}

variable "integration_baseline_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for integration_baseline"
}

variable "integration_baseline_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for integration_baseline"
}

variable "integration_baseline_session_token" {
  type        = string
  description = "the AWS_SESSION_TOKEN for integration_baseline"
}

variable "preprod_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for Q Solution preprod"
}

variable "preprod_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for Q Solution preprod"
}

variable "preprod_session_token" {
  type        = string
  description = "the AWS_SESSION_TOKEN for Q Solution preprod"
}

variable "production_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for Q Solution production"
}

variable "production_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for Q Solution production"
}

variable "production_session_token" {
  type        = string
  description = "the AWS_SESSION_TOKEN for Q Solution production"
}

variable "region" {
  description = "The AWS region"
  default     = "eu-west-2"
}

variable "parent_zone_id" {
  description = "The zone id of our parent hosted zone"
  type        = string
  default     = "Z0532960253T16WMNSRNR"
}

variable "slack_webhook" {
  description = "Our webhook for sending messages to slack"
  type        = string
  default     = ""
}
