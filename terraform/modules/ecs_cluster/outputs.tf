output "ecs_cluster" {
  description = "The ecs cluster outputs"
  value       = var.create_cluster ? aws_ecs_cluster.cluster[0].id : data.aws_ecs_cluster.cluster[0].id
}

output "ecs_task" {
  description = "The ecs task outputs"
  value       = aws_ecs_task_definition.task_definition
}

output "ecs_service_role" {
  description = "The outputs of the service role"
  value       = aws_iam_role.ecs_service_role
}

output "ecs_service" {
  description = "The outputs of the ecs service"
  value       = aws_ecs_service.ecs_service
}
