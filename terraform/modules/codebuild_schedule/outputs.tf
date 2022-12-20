output "cloudwatch_event_rule" {
  description = "Our cloudwatch event"
  value       = aws_cloudwatch_event_rule.trigger_codebuild_build
}

output "cloudwatch_event_target" {
  description = "Our event target"
  value       = aws_cloudwatch_event_target.trigger_codebuild_build_target
}
