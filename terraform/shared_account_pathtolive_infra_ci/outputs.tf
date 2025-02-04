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
  description = "A list of all the subnet ids"
  value       = module.codebuild_base_resources.codebuild_subnet_ids
}

output "codebuild_private_subnet_ids" {
  description = "A list of all the subnet ids"
  value       = module.codebuild_base_resources.codebuild_private_subnet_ids
}

output "codebuild_public_subnet_ids" {
  description = "A list of public subnet ids"
  value       = module.codebuild_base_resources.codebuild_public_subnet_ids
}

output "codebuild_private_cidr_blocks" {
  description = "A list of private cidr blocks"
  value       = module.codebuild_base_resources.codebuild_private_cidrs
}

output "codebuild_public_cidr_blocks" {
  description = "A list of private cidr blocks"
  value       = module.codebuild_base_resources.codebuild_public_cidrs
}

output "codebuild_security_group_id" {
  description = "The VPC security group id used by codebuild"
  value       = module.codebuild_base_resources.codebuild_security_group_id
}

output "codebuild_security_group_ids" {
  description = "The VPC security group ids used by codebuild"
  value       = module.codebuild_base_resources.codebuild_security_group_ids
}

output "bichard_liberty_ecr" {
  description = "The Bichard Liberty ecr repository details"
  value       = module.codebuild_docker_resources.bichard_liberty_ecr
}

output "codebuild_zone_id" {
  description = "The public zone id for our codebuild VPC route53 zone"
  value       = aws_route53_zone.codebuild_public_zone.id
}

output "ssl_certificate_arn" {
  description = "The arn for our ACM ssl certificate"
  value       = aws_acm_certificate.bichard7_pathtolive_delegated_zone.arn
}

output "codepipeline_bucket" {
  description = "The name of the codebuild/pipeline bucket"
  value       = module.codebuild_base_resources.codepipeline_bucket

}
