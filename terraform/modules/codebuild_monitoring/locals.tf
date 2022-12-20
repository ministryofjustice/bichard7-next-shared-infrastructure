locals {
  grafana_alb_name = (length("${var.name}-grafana") > 32) ? trim(substr("${var.name}-grafana", 0, 32), "-") : "${var.name}-grafana"

  grafana_alb_name_prefix = lower(substr(replace("G${var.tags["Environment"]}", "-", ""), 0, 6))

  ecr_account_id = data.aws_caller_identity.current.account_id

  application_cpu    = (ceil(var.fargate_cpu / 6) * 5)
  application_memory = (ceil(var.fargate_memory / 6) * 5)
  config_cpu         = var.fargate_cpu - local.application_cpu
  config_memory      = var.fargate_memory - local.application_memory

  grafana_domain    = "monitoring.${data.aws_route53_zone.public_zone.name}"
  grafana_data_path = "/grafana"

  admins  = sort([for user in data.aws_iam_group.admins.users : user["user_name"]])
  viewers = sort([for user in data.aws_iam_group.viewers.users : user["user_name"]])
}
