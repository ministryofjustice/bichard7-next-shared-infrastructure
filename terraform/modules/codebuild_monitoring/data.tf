data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "public_zone" {
  zone_id = var.public_zone_id
}

data "aws_availability_zones" "current" {
  state = "available"
}

data "template_file" "allow_kms_access" {
  template = file("${path.module}/policies/allow_kms.json.tpl")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
  }
}

### Grafana
data "template_file" "grafana_ecs_task" {
  template = file("${path.module}/templates/grafana.json.tpl")

  vars = {
    grafana_image      = var.grafana_image
    region             = data.aws_region.current.name
    application_cpu    = var.fargate_cpu
    application_memory = var.fargate_memory
    log_group          = aws_cloudwatch_log_group.codebuild_monitoring.name

    exporter_log_stream_prefix = "grafana"

    ## Grafana Config for Env Vars
    grafana_domain             = local.grafana_domain
    database_type              = "postgres"
    database_host              = aws_rds_cluster.grafana_db.endpoint
    database_name              = aws_rds_cluster.grafana_db.database_name
    database_user              = aws_ssm_parameter.grafana_db_username.value
    database_password_arn      = aws_ssm_parameter.grafana_db_password.arn
    grafana_admin              = aws_ssm_parameter.grafana_admin_username.value
    grafana_admin_password_arn = aws_ssm_parameter.grafana_admin_password.arn
    grafana_secret_key_arn     = aws_ssm_parameter.grafana_secret_key.arn

    domain = data.aws_route53_zone.public_zone.name

    # Grafana Dashboard Config
    environment = var.tags["Environment"]
  }
}

data "aws_iam_group" "admins" {
  group_name = "AdminAccess"
}

data "aws_iam_group" "viewers" {
  group_name = "ReadOnlyAccess"
}

## Lambda

data "archive_file" "codebuild_metrics_payload" {
  output_path = "/tmp/generate_build_metrics.zip"
  type        = "zip"

  source {
    content  = file("${path.module}/functions/generate_build_metrics.py")
    filename = "webhook.py"
  }
}

data "template_file" "codebuild_metrics_permissions" {
  template = file("${path.module}/policies/lambda_permissions.json.tpl")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}
