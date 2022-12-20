resource "aws_alb" "alb" {
  name = var.alb_name

  load_balancer_type = var.load_balancer_type
  ip_address_type    = "ipv4"
  subnets            = var.service_subnets
  security_groups    = var.alb_security_groups
  internal           = var.alb_is_internal #tfsec:ignore:AWS005

  access_logs {
    bucket  = var.logging_bucket_name
    enabled = (var.load_balancer_type == "application" && var.enable_alb_logging) ? true : false
    prefix  = "alb/${var.alb_name}"
  }

  enable_deletion_protection = (lower(var.tags["is-production"]) == "true") ? true : false
  drop_invalid_header_fields = true
  idle_timeout               = var.idle_timeout

  tags = var.tags
}

resource "aws_lb_target_group" "alb_target_group" {
  count = (local.is_sticky == true) ? 0 : 1

  name_prefix = var.alb_name_prefix
  port        = var.alb_port
  protocol    = var.alb_protocol
  vpc_id      = var.vpc_id
  target_type = var.alb_target_type
  slow_start  = var.alb_slow_start

  health_check {
    healthy_threshold   = lookup(var.alb_health_check, "healthy_threshold", null)
    interval            = lookup(var.alb_health_check, "interval", null)
    protocol            = lookup(var.alb_health_check, "protocol", null)
    unhealthy_threshold = lookup(var.alb_health_check, "unhealthy_threshold", null)
    matcher             = lookup(var.alb_health_check, "matcher", null)
    path                = lookup(var.alb_health_check, "path", null)
    timeout             = lookup(var.alb_health_check, "timeout", null)
  }


  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_lb_target_group" "sticky_alb_target_group" {
  count = (local.is_sticky == true) ? 1 : 0

  name_prefix = var.alb_name_prefix
  port        = var.alb_port
  protocol    = var.alb_protocol
  vpc_id      = var.vpc_id
  target_type = var.alb_target_type
  slow_start  = var.alb_slow_start

  health_check {
    healthy_threshold   = lookup(var.alb_health_check, "healthy_threshold", null)
    interval            = lookup(var.alb_health_check, "interval", null)
    protocol            = lookup(var.alb_health_check, "protocol", null)
    unhealthy_threshold = lookup(var.alb_health_check, "unhealthy_threshold", null)
    matcher             = lookup(var.alb_health_check, "matcher", null)
    path                = lookup(var.alb_health_check, "path", null)
    timeout             = lookup(var.alb_health_check, "timeout", null)
  }

  stickiness {
    type            = lookup(var.stickiness, "type", null)
    enabled         = lookup(var.stickiness, "enabled", null)
    cookie_duration = lookup(var.stickiness, "cookie_duration", null)
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_lb_listener" "alb_listener" {
  count = length(var.alb_listener)

  load_balancer_arn = aws_alb.alb.arn
  port              = lookup(var.alb_listener[count.index], "port")
  protocol          = lookup(var.alb_listener[count.index], "protocol") # tfsec:ignore:aws-elbv2-http-not-used

  ssl_policy = (lookup(var.alb_listener[count.index], "protocol") == "HTTPS" ?
    "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" : null
  )
  certificate_arn = lookup(var.alb_listener[count.index], "certificate_arn", null)

  dynamic "default_action" {
    for_each = var.default_action[count.index]
    content {
      type             = lookup(default_action.value, "type")
      target_group_arn = local.alb_target_group_arn

      dynamic "redirect" {
        for_each = var.redirect_config[count.index]

        content {
          path        = lookup(redirect.value, "path", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          status_code = lookup(redirect.value, "status_code", null)
          host        = lookup(redirect.value, "host", null)
          query       = lookup(redirect.value, "query", null)
        }
      }
    }
  }

  tags = var.tags
}
