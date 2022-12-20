output "target_group" {
  description = "The load balancer target group"
  value       = local.alb_output
}

output "dns_name" {
  description = "The internal dns name of our alb"
  value       = aws_alb.alb.dns_name
}

output "load_balancer" {
  description = "The outputs from our load balancer"
  value       = aws_alb.alb
}
