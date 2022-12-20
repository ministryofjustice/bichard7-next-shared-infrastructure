output "pipeline_name" {
  description = "The name of our code pipeline"
  value       = aws_codebuild_project.cb_project.name
}

output "pipeline_arn" {
  description = "The arn of our code pipeline"
  value       = aws_codebuild_project.cb_project.arn
}

output "pipeline_id" {
  description = "The id of our code pipeline"
  value       = aws_codebuild_project.cb_project.id
}

output "pipeline_service_role_name" {
  description = "The name of the service role so we can attach policies if needed"
  value       = aws_iam_role.service_role.name
}
