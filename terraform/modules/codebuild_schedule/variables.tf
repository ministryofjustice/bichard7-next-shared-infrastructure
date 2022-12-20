variable "tags" {
  description = "A map of resource tags"
  type        = map(string)
}

variable "codebuild_arn" {
  description = "The arn of our codebuild project we want to be triggered from cloudwatch"
  type        = string
}

variable "name" {
  description = "The name of the event trigger, we should use the build name so it's easier to match"
  type        = string
}

variable "cron_expression" {
  description = "Our cron expression for our job"
  type        = string
}
