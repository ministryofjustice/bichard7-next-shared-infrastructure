variable "tags" {
  type        = map(string)
  description = "A map of resource tags"
}

variable "child_account_ids" {
  type        = list(string)
  description = "A list of child account id's allowed access to specific docker repos"
  default     = []
}
