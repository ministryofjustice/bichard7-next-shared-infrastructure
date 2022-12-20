variable "tags" {
  type        = map(string)
  description = "A list of AWS tags"
}

variable "buckets" {
  description = "A list of shared buckets that the parent allows the children to access"
  type        = list(string)
  default     = []
}

variable "create_nuke_user" {
  description = "Do we want to create user to run AWS Nuke with"
  type        = bool
  default     = false
}
