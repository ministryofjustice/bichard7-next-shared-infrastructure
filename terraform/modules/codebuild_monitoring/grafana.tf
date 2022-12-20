module "codebuild_monitoring_ecs_cluster" {
  source       = "../ecs_cluster"
  cluster_name = "codebuild-monitoring"
  ecr_repository_arns = [
    var.grafana_repository_arn
  ]
  log_group_name           = aws_cloudwatch_log_group.codebuild_monitoring.name
  rendered_task_definition = base64encode(data.template_file.grafana_ecs_task.rendered)
  service_subnets          = var.service_subnets
  security_group_name      = aws_security_group.grafana_cluster_security_group.name
  assign_public_ip         = true

  container_count        = 1
  enable_execute_command = true
  fargate_cpu            = var.fargate_cpu
  fargate_memory         = var.fargate_memory

  ssm_resources = [
    aws_ssm_parameter.grafana_db_password.arn,
    aws_ssm_parameter.grafana_admin_password.arn,
    aws_ssm_parameter.grafana_secret_key.arn
  ]

  load_balancers = [
    {
      target_group_arn = module.codebuild_monitoring_ecs_alb.target_group.arn
      container_name   = "grafana"
      container_port   = 3000
    }
  ]

  tags = var.tags

  depends_on = [
    aws_security_group.grafana_cluster_security_group
  ]
}

module "codebuild_monitoring_ecs_alb" {
  source              = "../ecs_cluster_alb"
  alb_name            = local.grafana_alb_name
  alb_name_prefix     = local.grafana_alb_name_prefix
  service_subnets     = var.service_subnets
  alb_port            = 3000
  alb_protocol        = "HTTPS"
  logging_bucket_name = var.logging_bucket_name
  vpc_id              = var.vpc_id
  enable_alb_logging  = false
  alb_is_internal     = false

  alb_security_groups = [
    aws_security_group.grafana_alb_security_group.id
  ]

  alb_health_check = {
    healthy_threshold   = "3"
    port                = 3000
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = "/api/health"
    unhealthy_threshold = "10"
  }

  alb_listener = [
    {
      port     = 80
      protocol = "HTTP"
    },
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.ssl_certificate_arn
    }
  ]

  redirect_config = [
    [
      {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    ],
    []
  ]

  default_action = [
    [{
      type = "redirect"
    }],
    [{
      type = "forward"
    }]
  ]

  tags = var.tags
}

resource "aws_route53_record" "grafana_public_record" {
  name    = local.grafana_domain
  type    = "CNAME"
  zone_id = data.aws_route53_zone.public_zone.zone_id
  ttl     = 30

  records = [
    module.codebuild_monitoring_ecs_alb.dns_name
  ]
}

resource "grafana_api_key" "admin_api_key" {
  name            = "grafana_admin_key"
  role            = "Admin"
  seconds_to_live = 120

  depends_on = [
    time_sleep.wait_for_containers
  ]
}

resource "aws_ssm_parameter" "grafana_admin_api_key" {
  name      = "/${var.name}/codebuild_monitoring/grafana/api_key"
  type      = "SecureString"
  value     = grafana_api_key.admin_api_key.key
  overwrite = true

  tags = var.tags
}

resource "time_sleep" "wait_for_containers" {
  create_duration = "60s"

  depends_on = [
    module.codebuild_monitoring_ecs_cluster
  ]
}

resource "grafana_data_source" "cloudwatch" {
  name       = "${var.name}-cloudwatch"
  type       = "cloudwatch"
  is_default = true

  json_data {
    default_region = data.aws_region.current.name
    auth_type      = "file"

    custom_metrics_namespaces = "Codebuild,LogMetrics,Ecs/ContainerInsights"
  }

  depends_on = [
    time_sleep.wait_for_containers
  ]
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_ecs_cloudwatch" {
  name   = "${var.name}-allow-cloudwatch-read"
  policy = file("${path.module}/policies/allow_cloudwatch.json")
  role   = module.codebuild_monitoring_ecs_cluster.ecs_service_role.name
}
