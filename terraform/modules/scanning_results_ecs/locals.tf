locals {
  name            = "${var.name}-scanning"
  alb_name        = (length(var.name) > 32) ? trim(substr(var.name, 0, 32), "-") : var.name
  alb_name_prefix = lower(substr(replace(local.name, "-", ""), 0, 6))

  scanning_image = "${data.aws_ecr_repository.scanning_portal.repository_url}@${data.external.scanning_portal_latest_image.result.tags}"

  scanning_cpu_units    = ((var.fargate_cpu / 4) * 3)
  scanning_memory_units = ((var.fargate_memory / 4) * 3)
  config_cpu_units      = (var.fargate_cpu / 4)
  config_memory_units   = (var.fargate_memory / 4)

  scanning_reults_portal_fargate_policy = templatefile("${path.module}/templates/scanning_results.tpl", {
    scanning_results_portal_image = local.scanning_image
    scanning_cpu_units            = local.scanning_cpu_units
    scanning_memory_units         = local.scanning_memory_units
    config_volume                 = "data"
    bucket_name                   = var.scanning_bucket_name
    htpasswd_arn                  = aws_ssm_parameter.scanning_portal_password.arn
    access_key_arn                = aws_ssm_parameter.scanning_bucket_access_key.arn
    secret_key_arn                = aws_ssm_parameter.scanning_bucket_secret_key.arn
    config_cpu_units              = local.config_cpu_units
    config_memory_units           = local.config_memory_units

    log_group         = aws_cloudwatch_log_group.ecs_log_group.name
    log_stream_prefix = "scanning-results-portal"
    region            = data.aws_region.current.name
  })

  tags = merge(
    var.tags,
    {
      Name = local.name
    }
  )
}
