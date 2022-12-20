variable "tags" {
  description = "A map of infrastructure tags for our resources"
  type        = map(string)
}

variable "name" {
  description = "The bucket name prefix"
  type        = string
}

variable "bucket-object-name" {
  description = "The path to our statefile"
  type        = string
  default     = "/infra/tfstatefile"
}

variable "logging_bucket_name" {
  description = "The bucket we send our access logs to"
  type        = string
}
