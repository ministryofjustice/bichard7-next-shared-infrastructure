output "scanning_alb_dns" {
  description = "DNS entry for load balancer"
  value       = module.scanning_portal_ecs_alb.dns_name
}

output "scanning_fqdn" {
  description = "The public fqdn for the alb"
  value       = aws_route53_record.friendly_dns_name.fqdn
}
