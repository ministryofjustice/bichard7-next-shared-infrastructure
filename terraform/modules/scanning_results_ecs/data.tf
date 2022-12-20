data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "scanning_reults_portal_fargate" {
  template = file("${path.module}/templates/scanning_results.tpl")

  vars = {
    scanning_results_portal_image = local.scanning_image
    scanning_cpu_units            = local.scanning_cpu_units
    scanning_memory_units         = local.scanning_memory_units
    config_volume                 = "data"
    bucket_name                   = var.scanning_bucket_name
    htpasswd_arn                  = aws_ssm_parameter.scanning_portal_password.arn
    access_key_arn                = aws_ssm_parameter.scanning_bucket_access_key.arn
    secret_key_arn                = aws_ssm_parameter.scanning_bucket_secret_key.arn
    config_cpu_units              = local.config_cpu_units
    config_memory_units           = local.config_memory_units

    log_group         = aws_cloudwatch_log_group.ecs_log_group.name
    log_stream_prefix = "scanning-results-portal"
    region            = data.aws_region.current.name
  }
}

data "aws_route53_zone" "public" {
  zone_id = var.public_zone_id
}

data "aws_ecr_repository" "scanning_portal" {
  name = "nginx-scan-portal"
}

data "external" "scanning_portal_latest_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", data.aws_ecr_repository.scanning_portal.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageDigest)}",
  ]
}

data "template_file" "cloudwatch_encryption" {
  template = file("${path.module}/policies/cloudwatch_encryption.json.tpl")

  vars = {
    account_id               = data.aws_caller_identity.current.account_id
    region                   = data.aws_region.current.name
    scanning_bucket_user_arn = aws_iam_user.scanning_bucket_user.arn
  }
}

data "template_file" "scanning_user_policy" {
  template = file("${path.module}/policies/scanning_user_policy.json.tpl")

  vars = {
    scanning_bucket_name = var.scanning_bucket_name
  }
}
