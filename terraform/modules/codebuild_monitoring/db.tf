resource "random_string" "grafana_admin_suffix" {
  special = false
  length  = 12
}

resource "random_string" "grafana_dbuser" {
  special = false
  number  = false
  length  = 24
}

resource "random_password" "grafana_admin_password" {
  length  = 24
  special = false
}

resource "random_string" "grafana_secret_key" {
  length  = 24
  special = false
}

resource "random_password" "grafana_db_password" {
  length  = 24
  special = false
}

resource "aws_ssm_parameter" "grafana_admin_username" {
  name      = "/${var.name}/codebuild_monitoring/grafana/username"
  type      = "SecureString"
  value     = "grafana_${random_string.grafana_admin_suffix.result}"
  overwrite = true

  tags = var.tags
}

resource "aws_ssm_parameter" "grafana_admin_password" {
  name      = "/${var.name}/codebuild_monitoring/grafana/password"
  type      = "SecureString"
  value     = random_password.grafana_admin_password.result
  overwrite = true

  tags = var.tags
}

resource "aws_ssm_parameter" "grafana_db_username" {
  name      = "/${var.name}/codebuild_monitoring/grafana/db_username"
  type      = "SecureString"
  value     = random_string.grafana_dbuser.result
  overwrite = true

  tags = var.tags
}

resource "aws_ssm_parameter" "grafana_db_password" {
  name      = "/${var.name}/codebuild_monitoring/grafana/db_password"
  type      = "SecureString"
  value     = random_password.grafana_db_password.result
  overwrite = true

  tags = var.tags
}

resource "aws_ssm_parameter" "grafana_secret_key" {
  name      = "/${var.name}/codebuild_monitoring/grafana/secret"
  type      = "SecureString"
  value     = random_string.grafana_secret_key.result
  overwrite = true

  tags = var.tags
}

resource "aws_db_subnet_group" "grafana_subnet_group" {
  name        = "${var.name}_grafana_db_subnet_group"
  description = "Allowed subnets for Grafana DB instance"
  subnet_ids  = var.private_subnets

  tags = var.tags
}

resource "aws_kms_key" "aurora_cluster_encryption_key" {
  description             = "${var.name}-grafana-db-key"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "aurora_cluster_encryption_key_alias" {
  target_key_id = aws_kms_key.aurora_cluster_encryption_key.id
  name          = "alias/${var.name}-grafana-db-cluster"
}

resource "aws_rds_cluster" "grafana_db" {
  cluster_identifier = "${var.name}-grafana"

  enable_global_write_forwarding = false

  engine         = "aurora-postgresql"
  engine_version = "13.8"

  availability_zones = data.aws_availability_zones.current.names
  vpc_security_group_ids = [
    aws_security_group.grafana_db_security_group.id
  ]

  database_name   = "grafana"
  master_username = aws_ssm_parameter.grafana_db_username.value
  master_password = aws_ssm_parameter.grafana_db_password.value

  backup_retention_period   = (lower(var.tags["is-production"]) == "true") ? 35 : 14
  preferred_backup_window   = "23:30-00:00"
  copy_tags_to_snapshot     = true
  final_snapshot_identifier = "${var.name}-grafana-final-${random_string.grafana_admin_suffix.result}"

  enabled_cloudwatch_logs_exports = ["postgresql"]

  deletion_protection = (lower(var.tags["is-production"]) == "true") ? true : false

  apply_immediately            = (lower(var.tags["is-production"]) == "true") ? false : true
  preferred_maintenance_window = "wed:04:00-wed:04:30"

  storage_encrypted    = true
  kms_key_id           = aws_kms_key.aurora_cluster_encryption_key.arn
  db_subnet_group_name = aws_db_subnet_group.grafana_subnet_group.name

  tags = var.tags
}

resource "aws_rds_cluster_instance" "grafana_db_instance" {
  count = var.grafana_db_instance_count

  cluster_identifier   = aws_rds_cluster.grafana_db.id
  instance_class       = var.grafana_db_instance_class
  engine               = aws_rds_cluster.grafana_db.engine
  engine_version       = aws_rds_cluster.grafana_db.engine_version
  db_subnet_group_name = aws_db_subnet_group.grafana_subnet_group.name

  auto_minor_version_upgrade   = true
  preferred_maintenance_window = aws_rds_cluster.grafana_db.preferred_maintenance_window

  performance_insights_enabled          = true
  performance_insights_kms_key_id       = aws_kms_key.aurora_cluster_encryption_key.arn
  performance_insights_retention_period = (lower(var.tags["is-production"]) == "true") ? 731 : 7

  tags = var.tags
}
