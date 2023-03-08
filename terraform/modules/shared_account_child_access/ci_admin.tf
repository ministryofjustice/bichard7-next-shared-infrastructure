resource "aws_iam_role" "assume_ci_admin_access" {
  name                 = "Bichard7-CI-Admin-Access"
  max_session_duration = 10800
  assume_role_policy   = data.template_file.allow_assume_ci_admin_access.rendered

  tags = var.tags
}
