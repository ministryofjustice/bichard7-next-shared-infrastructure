locals {
  is_sticky            = (var.stickiness == null) ? false : true
  alb_target_group_arn = (local.is_sticky == true) ? aws_lb_target_group.sticky_alb_target_group[0].arn : aws_lb_target_group.alb_target_group[0].arn

  alb_output = (local.is_sticky == true) ? aws_lb_target_group.sticky_alb_target_group[0] : aws_lb_target_group.alb_target_group[0]
}
