variable "sandbox_a_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for sandbox_a"
}

variable "sandbox_a_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for sandbox_a"
}

variable "sandbox_b_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for sandbox_b"
}

variable "sandbox_b_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for sandbox_b"
}

variable "sandbox_c_access_key" {
  type        = string
  description = "the AWS_ACCESS_KEY_ID for sandbox_c"
}

variable "sandbox_c_secret_key" {
  type        = string
  description = "the AWS_SECRET_ACCESS_KEY for sandbox_c"
}

variable "region" {
  type        = string
  description = "The AWS region"
  default     = "eu-west-2"
}
