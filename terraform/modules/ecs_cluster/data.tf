data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "this" {}

data "template_file" "allow_kms_usage" {
  template = file("${path.module}/policies/allow_kms.json.tpl")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "allow_ecr_repository" {
  template = file("${path.module}/policies/allow_ecr.json.tpl")

  vars = {
    ecr_repos = jsonencode(var.ecr_repository_arns)
  }
}

data "template_file" "allow_ssm_parameters" {
  template = file("${path.module}/policies/allow_ssm.json.tpl")

  vars = {
    allowed_resources = jsonencode(var.ssm_resources)
  }
}

data "aws_security_group" "cluster_sg" {
  name = var.security_group_name
}

data "aws_ecs_cluster" "cluster" {
  count        = var.create_cluster == false ? 1 : 0
  cluster_name = var.cluster_name
}

data "template_file" "allow_ssm_messages" {
  count = var.enable_execute_command == true ? 1 : 0

  template = file("${path.module}/policies/allow_ssm_messages.json.tpl")

  vars = {
    region              = data.aws_region.current.name
    account             = data.aws_caller_identity.current.account_id
    log_group_name      = var.log_group_name
    logging_bucket_name = var.logging_bucket_name
    key_arn             = aws_kms_key.cluster_logs_encryption_key.arn
  }
}

data "template_file" "allow_ssm_messages_external_kms" {
  count = (var.enable_execute_command == true && var.remote_cluster_kms_key_arn != null) ? 1 : 0

  template = file("${path.module}/policies/allow_ssm_messages.json.tpl")

  vars = {
    region              = data.aws_region.current.name
    account             = data.aws_caller_identity.current.account_id
    log_group_name      = var.log_group_name
    logging_bucket_name = var.logging_bucket_name
    key_arn             = var.remote_cluster_kms_key_arn
  }
}

data "template_file" "allow_admin_cmk_access" {
  count = (var.create_cluster == true) ? 1 : 0

  template = file("${path.module}/policies/allow_admin_cmk_access.json.tpl")

  vars = {
    logs_encryption_key_arn = aws_kms_key.cluster_logs_encryption_key.arn
  }
}

data "aws_iam_role" "admin_role" {
  name = "Bichard7-Administrator-Access"
}
