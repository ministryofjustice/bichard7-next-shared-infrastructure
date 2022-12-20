variable "codebuild_project_name" {
  description = "The name of the codebuild project we want to attach this webhook to"
  type        = string
}

variable "git_ref" {
  description = "Our git ref that we want to use for our trigger"
  type        = string
  default     = "main"
}

variable "filter_event_type" {
  description = "The type of event we're triggering this webhook with"
  default     = "EVENT"
  type        = string
}

variable "filter_event_pattern" {
  description = "The pattern we're using to filter this event"
  default     = "PUSH"
  type        = string
}
