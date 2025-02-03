locals {
  allow_codestar_kms_policy = templatefile("${path.module}/policies/allow_codestar_kms.json.tpl", {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })

  codebuild_vpc_config_blocks = { for env, sg in aws_security_group.environment_codebuild_vpc_sgs : env =>
    [
      {
        vpc_id  = module.vpc.vpc_id
        subnets = module.vpc.private_subnets
        security_group_ids = [
          module.vpc.default_security_group_id,
          aws_security_group.codebuild_vpc_sg.id,
          sg.id
        ]
      }
    ]
  }
}
