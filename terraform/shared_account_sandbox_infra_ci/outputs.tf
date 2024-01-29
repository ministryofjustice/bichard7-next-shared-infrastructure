output "staged_docker_resources" {
  description = "The outputs from our staged docker images module"
  value       = module.codebuild_docker_resources
}

output "base_resources" {
  description = "The outputs for our base resources"
  value       = module.codebuild_base_resources
}

output "codebuild_vpc_id" {
  description = "The vpc ID for our codebuild vpc"
  value       = module.codebuild_base_resources.codebuild_vpc_id
}

output "codebuild_cidr_block" {
  description = "The cidr block for our codebuild vpc"
  value       = module.codebuild_base_resources.codebuild_cidr_block
}

output "codebuild_subnet_ids" {
  description = "A list of private subnet ids"
  value       = module.codebuild_base_resources.codebuild_subnet_ids
}

output "codebuild_private_cidr_blocks" {
  description = "A list of private cidr blocks"
  value       = module.codebuild_base_resources.codebuild_private_cidrs
}

output "bichard_liberty_ecr" {
  description = "The Bichard Liberty ecr repository details"
  value       = module.codebuild_docker_resources.bichard_liberty_ecr
}
