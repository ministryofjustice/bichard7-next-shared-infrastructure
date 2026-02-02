variable "child_account_id" {
  description = "The child accounts id"
  type        = string
}

variable "admin_access_group_name" {
  description = "The name of the admin group"
  type        = string
}

variable "readonly_access_group_name" {
  description = "The name of the readonly group"
  type        = string
}

variable "ci_access_group_name" {
  description = "The name of the CI group"
  type        = string
}

variable "admin_access_arn" {
  description = "The child admin assume role arn"
  type        = string
}

variable "aws_support_access_arn" {
  description = "The child aws support assume role arn"
  type        = string
}

variable "readonly_access_arn" {
  description = "The child readonly assume role arn"
  type        = string
}

variable "ci_access_arn" {
  description = "The child ci assume role arn"
  type        = string
}

variable "ci_admin_access_arn" {
  description = "The child aws ci admin assume role arn"
  type        = string
}

variable "aws_nuke_access_arn" {
  description = "The child aws nuke assume role arn"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to apply to our resources"
  type        = map(string)
}
