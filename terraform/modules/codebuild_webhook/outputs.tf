output "codebuild_webhook" {
  description = "The outputs from our codebuild webhook"
  value       = aws_codebuild_webhook.trigger_build
}
