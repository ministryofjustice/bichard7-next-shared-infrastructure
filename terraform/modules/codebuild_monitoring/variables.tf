variable "tags" {
  type        = map(string)
  description = "A map of environment tags"
  default     = {}
}

variable "fargate_cpu" {
  description = "The number of cpu units"
  type        = number
  default     = 1024
}

variable "fargate_memory" {
  description = "The amount of memory that will be given to fargate in Megabytes"
  type        = number
  default     = 2048
}

variable "name" {
  description = "The deployments name"
  type        = string
}

variable "vpc_id" {
  description = "The vpc id for our security groups to bind to"
  type        = string
}

variable "service_subnets" {
  description = "A list of our subnets"
  type        = list(string)
}

variable "public_zone_id" {
  description = "The zone id for our public hosted zone so we can use ACM certificates"
  type        = string
}

variable "logging_bucket_name" {
  description = "The default logging bucket for lb access logs"
  type        = string
}

variable "grafana_image" {
  description = "The url of our grafana ecs image we want to use"
  type        = string
}

variable "remote_exec_enabled" {
  description = "Do we want to allow remote-exec onto these containers"
  type        = bool
  default     = true
}

variable "grafana_db_instance_class" {
  description = "The class of DB instance we are using for Grafana"
  default     = "db.t4g.medium"
  type        = string
}

variable "grafana_db_instance_count" {
  description = "The number of DB instance we are using for Grafana"
  default     = 3
  type        = number
}

variable "using_smtp_service" {
  description = "Are we using the CJSM smtp service"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "How long in seconds before we terminate a connection"
  type        = number
  default     = 180
}

variable "ssl_certificate_arn" {
  description = "The arn of our acm certificate"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets to deploy our db into"
  type        = list(string)
}

variable "grafana_repository_arn" {
  description = "The arn of our grafana repository"
  type        = string
}
