variable "name" {
  description = "The name of the resource, used as a prefix"
  type        = string
}

variable "tags" {
  description = "A map of resource tags"
  type        = map(string)
  default     = {}
}

variable "logging_bucket" {
  description = "The name of the logging bucket we want to log our s3 information to"
  type        = string
}
