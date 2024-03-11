resource "aws_kms_key" "cluster_logs_encryption_key" {
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "cluster_logs_encryption_key" {
  target_key_id = aws_kms_key.cluster_logs_encryption_key.arn
  name          = "alias/${local.service_name}-log-encryption"
}

resource "aws_iam_role_policy" "allow_admin_role_cmk_access" {
  count = var.create_cluster ? 1 : 0

  name = "${local.service_name}-allow-admin-cmk-access"
  policy = templatefile("${path.module}/policies/allow_admin_cmk_access.json.tpl", {
    logs_encryption_key_arn = aws_kms_key.cluster_logs_encryption_key.arn
  })
  role = data.aws_iam_role.admin_role.name
}

resource "aws_ecs_cluster" "cluster" {
  count = var.create_cluster ? 1 : 0

  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.cluster_logs_encryption_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = var.log_group_name
      }
    }
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = local.service_name
  execution_role_arn       = aws_iam_role.ecs_service_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.fargate_memory
  cpu                      = var.fargate_cpu

  task_role_arn         = aws_iam_role.ecs_service_role.arn
  container_definitions = base64decode(var.rendered_task_definition)


  # This will need to be enabled when we refactor the monitoring ecs task, we're leaving that on the old structure for now
  # as we need to figure out our approach to monitoring
  dynamic "volume" {
    for_each = var.volumes
    content {
      name = lookup(volume.value, "name", "data")
      //        dynamic "efs_volume_configuration" {
      //          for_each = var.efs_volume_configuration
      //          content {
      //            file_system_id     = lookup(efs_volume_configuration, "file_system_id", null)
      //            transit_encryption = lookup(efs_volume_configuration, "file_system_id", null)
      //            root_directory     = lookup(efs_volume_configuration, "root_directory", null)
      //          }
      //        }
    }
  }
  tags = var.tags
}

resource "aws_ecs_service" "ecs_service" {
  name                   = local.service_name
  cluster                = ((var.create_cluster) ? aws_ecs_cluster.cluster[0].id : data.aws_ecs_cluster.cluster[0].id)
  desired_count          = local.container_count
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.task_definition.arn
  enable_execute_command = var.enable_execute_command

  network_configuration {
    security_groups  = [data.aws_security_group.cluster_sg.id]
    subnets          = var.service_subnets
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
      target_group_arn = load_balancer.value["target_group_arn"]
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = local.service_name
  log_group_name = var.log_group_name
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "${local.service_name}-Ecs-Task"
  assume_role_policy = file("${path.module}/policies/assume_role.json")

  tags = var.tags
}

resource "aws_iam_role_policy" "allow_ecr" {
  name = "${local.service_name}-ecr"
  role = aws_iam_role.ecs_service_role.id
  policy = templatefile("${path.module}/policies/allow_ecr.json.tpl", {
    ecr_repos = jsonencode(var.ecr_repository_arns)
  })
}

resource "aws_iam_role_policy" "allow_kms" {
  name = "${local.service_name}-kms"
  role = aws_iam_role.ecs_service_role.id
  policy = templatefile("${path.module}/policies/allow_kms.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role_policy" "allow_ssm" {
  count = (length(var.ssm_resources) > 0 ? 1 : 0)

  name = "${local.service_name}-ssm"
  role = aws_iam_role.ecs_service_role.id
  policy = templatefile("${path.module}/policies/allow_ssm.json.tpl", {
    allowed_resources = jsonencode(var.ssm_resources)
  })
}

resource "aws_iam_role_policy" "allow_ssm_messages" {
  count = var.enable_execute_command == true ? 1 : 0

  name = "${local.service_name}-ssm-messages"
  policy = templatefile("${path.module}/policies/allow_ssm_messages.json.tpl", {
    region              = data.aws_region.current.name
    account             = data.aws_caller_identity.current.account_id
    log_group_name      = var.log_group_name
    logging_bucket_name = var.logging_bucket_name
    key_arn             = aws_kms_key.cluster_logs_encryption_key.arn
  })
  role = aws_iam_role.ecs_service_role.id
}

resource "aws_iam_role_policy" "allow_ssm_messages_external_kms" {
  count = (var.enable_execute_command == true && var.remote_cluster_kms_key_arn != null) ? 1 : 0

  name = "${local.service_name}-external-ssm-messages"
  policy = templatefile("${path.module}/policies/allow_ssm_messages.json.tpl", {
    region              = data.aws_region.current.name
    account             = data.aws_caller_identity.current.account_id
    log_group_name      = var.log_group_name
    logging_bucket_name = var.logging_bucket_name
    key_arn             = var.remote_cluster_kms_key_arn
  })
  role = aws_iam_role.ecs_service_role.id
}

resource "aws_iam_role_policy_attachment" "attach_ecs_code_deploy_role_for_ecs" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "attach_ecs_task_execution" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
