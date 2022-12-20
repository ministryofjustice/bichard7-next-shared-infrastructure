variable "tags" {
  description = "A map of resource tags"
  type        = map(string)
}

variable "name" {
  description = "Our resource name"
  type        = string
}

variable "notifications_channel_name" {
  default     = "moj-cjse-bichard-notifications"
  type        = string
  description = "Our slack channel for build notifications"
}

variable "is_path_to_live" {
  default     = false
  type        = bool
  description = "use this to deploy to our parent path to live account"
}
