resource "random_password" "admin_password" {
  count = length(local.admins)

  length  = 16
  special = false
}

resource "aws_ssm_parameter" "admin_password" {
  count = length(local.admins)

  name      = "/${var.name}/codebuild_monitoring/grafana/admins/${split("@", local.admins[count.index])[0]}"
  type      = "SecureString"
  value     = random_password.admin_password[count.index].result
  overwrite = true

  tags = var.tags
}

resource "grafana_user" "admin_user" {
  count = length(local.admins)

  email    = local.admins[count.index]
  login    = local.admins[count.index]
  password = random_password.admin_password[count.index].result
  is_admin = true
}

resource "random_password" "readonly_password" {
  count = length(local.viewers)

  length  = 16
  special = false
}

resource "aws_ssm_parameter" "readonly_password" {
  count = length(local.viewers)

  name      = "/${var.name}/codebuild_monitoring/grafana/viewers/${split("@", local.viewers[count.index])[0]}"
  type      = "SecureString"
  value     = random_password.readonly_password[count.index].result
  overwrite = true

  tags = var.tags
}

resource "grafana_user" "readonly_user" {
  count = length(local.viewers)

  email    = local.viewers[count.index]
  login    = local.viewers[count.index]
  password = random_password.readonly_password[count.index].result
  is_admin = false
}
