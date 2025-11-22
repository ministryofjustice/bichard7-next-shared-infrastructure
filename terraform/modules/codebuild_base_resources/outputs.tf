output "codepipeline_bucket_arn" {
  description = "The arn of our bucket"
  value       = aws_s3_bucket.codebuild_artifact_bucket.arn
}

output "codepipeline_bucket" {
  description = "The name of our bucket"
  value       = aws_s3_bucket.codebuild_artifact_bucket.bucket
}

output "notifications_arn" {
  description = "The arn of our sns topic"
  value       = aws_sns_topic.build_notifications.arn
}

output "notifications_slack_webhook_path" {
  description = "The ssm path for our slack webhook"
  value       = aws_ssm_parameter.slack_webhook.name
}

output "notifications_kms_key_arn" {
  description = "The notifications KMS key"
  value       = aws_kms_key.build_notifications_key.arn
}

output "scanning_results_bucket" {
  description = "The name of our scanning results bucket"
  value       = aws_s3_bucket.scanning_results_bucket.bucket
}

output "scanning_notifications_arn" {
  description = "The arn of our scanning sns topic"
  value       = aws_sns_topic.scanning_notifications.arn
}

output "scanning_notifications_kms_key_arn" {
  description = "The scanning notifications KMS key"
  value       = aws_kms_key.scanning_notifications_key.arn
}

output "concurrency_dynamo_db_table" {
  description = "The dynamotable we are going to use for concurrency locks"
  value = {
    name = aws_dynamodb_table.codebuild_lock_table.name
    arn  = aws_dynamodb_table.codebuild_lock_table.arn
  }
}

output "codebuild_vpc_id" {
  description = "The vpc id for our codebuild jobs"
  value       = module.vpc.vpc_id
}

output "codebuild_public_cidrs" {
  description = "The external cidrs for our codebuild vpc"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "codebuild_private_cidrs" {
  description = "The internal cidrs for our codebuild vpc"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "codebuild_nat_gateway_ids" {
  description = "The nat gateway ids for our public subnets"
  value       = module.vpc.natgw_ids
}

output "codebuild_security_group_id" {
  description = "The allowed security group id for our codebuild_vpc"
  value       = aws_security_group.codebuild_vpc_sg.id
}

output "codebuild_security_group_ids" {
  description = "Mapping of environment names to their security group IDs"
  value       = { for env, sg in aws_security_group.environment_codebuild_vpc_sgs : env => sg.id }
}

output "codebuild_vpc_config_block" {
  description = "A preformed config block to pass to codebuild"
  value = [
    {
      vpc_id  = module.vpc.vpc_id
      subnets = module.vpc.private_subnets
      security_group_ids = [
        module.vpc.default_security_group_id,
        aws_security_group.codebuild_vpc_sg.id
      ]
    }
  ]
}

output "codebuild_vpc_config_blocks" {
  description = "A preformed config block to pass to codebuild"
  value       = local.codebuild_vpc_config_blocks
}

output "codebuild_cidr_block" {
  description = "Our CIDR block for codebuild"
  value       = local.cidr_block
}

output "codebuild_subnet_ids" {
  description = "A list of private subnet ids"
  value       = concat(module.vpc.private_subnets, module.vpc.public_subnets)
}

output "codebuild_private_subnet_ids" {
  description = "A list of private subnet ids"
  value       = module.vpc.private_subnets
}

output "codebuild_public_subnet_ids" {
  description = "A list of public subnet ids"
  value       = module.vpc.public_subnets
}

output "codebuild_private_cidr_blocks" {
  description = "A list of private cidr blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "codebuild_public_cidr_blocks" {
  description = "A list of public cidr blocks"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "codepipeline_vpc_endpoint_id" {
  description = "The ID of the CodePipeline VPC endpoint"
  value       = aws_vpc_endpoint.codepipeline_vpc_endpoint.id
}

output "codebuild_vpc_sgs" {
  description = "The CodeBuild VPC security groups"
  value       = aws_security_group.environment_codebuild_vpc_sgs
}
