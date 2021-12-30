variable "codebuild_s3_bucket" {
  description = "The name of our codebuild bucket used for logs and artificacts"
  type        = string
}

variable "vpc_config_block" {
  description = "The config block for our vpc"
  type        = any
  default     = []
}

variable "sns_notifications_arn" {
  description = "The notifications arn for SNS"
  type        = string
}

variable "tags" {
  description = "A map of tags for our infrastructure"
  type        = map(string)
}

variable "notifications_kms_key_arn" {
  description = "The arn for our notifications KMS key"
  type        = string
}

variable "environment" {
  description = "The environment we're applying this to sandbox/pathtolive"
  type        = string
}

variable "bichard_cd_env_vars" {
  description = "A list of maps of env var strings"
  type        = list(map(string))
  default     = []
}

variable "audit_logging_cd_env_vars" {
  description = "A list of maps of env var strings"
  type        = list(map(string))
  default     = []
}

variable "user_service_cd_env_vars" {
  description = "A list of maps of env var strings"
  type        = list(map(string))
  default     = []
}

variable "beanconnect_cd_env_vars" {
  description = "A list of maps of env var strings"
  type        = list(map(string))
  default     = []
}

variable "reporting_cd_env_vars" {
  description = "A list of maps of env var strings"
  type        = list(map(string))
  default     = []
}

variable "scanning_results_bucket" {
  description = "bucket to store scanning results"
  type        = string
}

variable "common_cd_vars" {
  description = "A list of maps of env var strings"
  type        = list(map(string))
  default     = []
}
