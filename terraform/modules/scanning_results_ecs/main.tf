resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name       = "scanning-results-portal"
  kms_key_id = aws_kms_key.cloudwatch_encryption.arn

  tags = var.tags
}

module "scanning_portal_ecs_alb" {
  source = "../ecs_cluster_alb"
  alb_security_groups = [
    aws_security_group.scanning_portal_alb.id
  ]
  alb_is_internal     = false
  alb_protocol        = "HTTPS"
  service_subnets     = var.service_subnets
  alb_name            = local.alb_name
  alb_name_prefix     = local.alb_name_prefix
  alb_port            = 443
  logging_bucket_name = var.logging_bucket_name
  vpc_id              = var.vpc_id
  enable_alb_logging  = false

  alb_health_check = {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = "/elb-status"
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

  tags = local.tags

  depends_on = [
    aws_security_group.scanning_portal_alb
  ]
}

module "scanning_portal_ecs_service" {
  source       = "../ecs_cluster"
  cluster_name = local.name
  ecr_repository_arns = [
    data.aws_ecr_repository.scanning_portal.arn
  ]

  assign_public_ip = true

  ssm_resources = [
    aws_ssm_parameter.scanning_portal_password.arn,
    aws_ssm_parameter.scanning_bucket_access_key.arn,
    aws_ssm_parameter.scanning_bucket_secret_key.arn
  ]

  log_group_name           = aws_cloudwatch_log_group.ecs_log_group.name
  rendered_task_definition = base64encode(scanning_reults_portal_fargate_policy)
  security_group_name      = aws_security_group.scanning_portal_container.name
  service_subnets          = var.service_subnets
  container_count          = var.desired_instance_count
  load_balancers = [
    {
      target_group_arn = module.scanning_portal_ecs_alb.target_group.arn
      container_name   = "scanning_results"
      container_port   = 443
    }
  ]

  volumes = []

  fargate_cpu    = var.fargate_cpu
  fargate_memory = var.fargate_memory

  tags = local.tags

  depends_on = [
    aws_security_group.scanning_portal_container
  ]
}

resource "aws_route53_record" "friendly_dns_name" {
  name    = "scanning.${data.aws_route53_zone.public.name}"
  type    = "CNAME"
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = 30
  records = [
    module.scanning_portal_ecs_alb.dns_name
  ]
}
