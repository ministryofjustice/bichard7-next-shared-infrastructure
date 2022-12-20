variable "tags" {
  description = "A map of tags for our resource"
  type        = map(string)
}

variable "cluster_name" {
  description = "The name of our resource"
  type        = string
}

variable "create_cluster" {
  description = "Are we creating the cluster"
  type        = bool
  default     = true
}

variable "ecr_repository_arns" {
  description = "A list of ecr repository arns we are allowed access to"
  type        = list(string)
}

variable "security_group_name" {
  description = "The name of the security group used on the cluster"
  type        = string
}

variable "log_group_name" {
  description = "The name of the log group we are publishing to"
  type        = string
}

variable "fargate_cpu" {
  description = "The number of cpu units this task has"
  type        = number
  default     = 1024
}

variable "fargate_memory" {
  description = "The number of memory units this task has"
  type        = number
  default     = 4096
}

variable "rendered_task_definition" {
  description = "The rendered task definition file base64 encoded"
  type        = string
}

variable "container_count" {
  description = "The number of containers we require, defaults to one per AZ"
  type        = number
  default     = null
}

variable "load_balancers" {
  description = "A map of maps of load balancer configurations"
  type        = list(map(string))
  default     = []
}

variable "service_subnets" {
  description = "A list of subnets this load balancer will connect to"
  type        = list(string)
}

variable "ssm_resources" {
  description = "A list of ssm resources we can access"
  type        = list(string)
  default     = []
}

variable "volumes" {
  description = "A list of volumes that we will attach to the container"
  type        = any
  default     = []
}

variable "efs_volume_configuration" {
  type    = any
  default = []
}

variable "assign_public_ip" {
  description = "Do we assign a public ip to our containers"
  type        = bool
  default     = false
}

variable "enable_execute_command" {
  description = "Allow us to exec into a container"
  type        = bool
  default     = false
}

variable "logging_bucket_name" {
  description = "The name of our s3 logging bucket, only required if we are enabling ecs exec"
  type        = string
  default     = null
}

variable "remote_cluster_kms_key_arn" {
  description = "If we are using an externally created cluster and want to use execute command we need to pass in the kms key arn"
  type        = string
  default     = null
}

variable "service_name" {
  description = "The name of the service in the cluster"
  type        = string
  default     = null
}
