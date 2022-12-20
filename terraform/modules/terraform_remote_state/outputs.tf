output "aws_s3_bucket" {
  description = "The name of our remote state bucket"
  value       = aws_s3_bucket.terraform_remote_state
}

output "aws_dynamodb_table" {
  description = "The name of our remote state bucket"
  value       = aws_dynamodb_table.terraform_state_lock
}

output "bucket_object_name" {
  description = "The name of our remote state bucket object"
  value       = var.bucket-object-name
}
