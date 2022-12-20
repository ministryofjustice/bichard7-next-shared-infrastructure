variable "alb_name" {
  description = "The name of our alb"
  type        = string
}

variable "service_subnets" {
  description = "The subnets on which our alb will serve traffic"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "The id of our vpc"
  type        = string
}

variable "alb_listener" {
  description = "Configuration for our listeners"
  type        = any
}

variable "alb_name_prefix" {
  description = "The name prefix for our alb"
  type        = string
}

variable "alb_port" {
  description = "The port our alb is listening on"
  type        = number
}

variable "alb_protocol" {
  description = "The protocol in use on the alb"
  type        = string
  default     = "TCP"
}

variable "alb_target_type" {
  description = "The target type our alb is using"
  type        = string
  default     = "ip"
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application, gateway, or network"
  type        = string
  default     = "application"
}

variable "logging_bucket_name" {
  description = "The name of our logging bucket to ship our alb access logs to"
  type        = string
}

variable "alb_security_groups" {
  description = "A list of security group ids for our load balancer only valid for application load balancers"
  type        = list(string)
  default     = null
}

variable "alb_is_internal" {
  description = "Is our alb internal only, defaults to true"
  type        = bool
  default     = true
}

variable "alb_health_check" {
  description = "A map containing our alb health check"
  type        = map(string)
  default = {
    healthy_threshold   = 10
    interval            = 30
    protocol            = "TCP"
    unhealthy_threshold = 10
  }
}

variable "alb_slow_start" {
  description = "Do we need a warm up period for our application"
  type        = number
  default     = 0
}

variable "stickiness" {
  description = "A map containing any sticky session settings"
  type        = map(string)
  default     = null
}

variable "default_action" {
  description = "A list of list of maps of our default action"
  type        = any
  default     = []
}

variable "redirect_config" {
  description = "A list of list of maps of our redirect configuration, order is important as we look this up based on the count index of the module"
  type        = any
  default     = [[]]
}

variable "enable_alb_logging" {
  description = "Do we want to enable alb logging (hint, yes, yes we do)"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "How long in seconds before we terminate a connection"
  type        = number
  default     = 180
}
