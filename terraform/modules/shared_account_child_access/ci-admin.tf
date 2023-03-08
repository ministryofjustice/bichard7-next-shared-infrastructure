resource "aws_iam_role" "assume_ci_admin_access" {
  count                = (var.create_nuke_user == true) ? 1 : 0
  name                 = "Bichard7-CI-Admin-Access"
  max_session_duration = 10800
  assume_role_policy   = data.template_file.allow_assume_ci_admin_access.rendered

  tags = var.tags
}
