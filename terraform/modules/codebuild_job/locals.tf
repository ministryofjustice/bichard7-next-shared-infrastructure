locals {
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  allowed_resources = compact(
    concat(
      var.allowed_resource_arns,
      [
        "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/ci/*",
        "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/nuke/*",
        "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
        "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:alias/*"
      ]
    )
  )

  environment_variables = concat([{
    name  = "AWS_ACCOUNT_ID"
    value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    },
    {
      name  = "AWS_ACCESS_KEY_ID"
      value = data.aws_ssm_parameter.access_key_id.name
      type  = "PARAMETER_STORE"
    },
    {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = data.aws_ssm_parameter.secret_access_key.name
      type  = "PARAMETER_STORE"
    },
    {
      name  = "TF_IN_AUTOMATION"
      value = "true"
    }],
    var.environment_variables
  )
}
