data "template_file" "allow_assume_administrator_access" {
  template = file("${path.module}/policies/allow_assume_admin_access.json.tpl")

  vars = {
    admin_access_arn = var.admin_access_arn
  }
}

data "template_file" "allow_assume_ci_access" {
  template = file("${path.module}/policies/allow_assume_ci_access.json.tpl")

  vars = {
    ci_access_arn = var.ci_access_arn
  }
}

data "template_file" "allow_assume_readonly_access" {
  template = file("${path.module}/policies/allow_assume_readonly_access.json.tpl")

  vars = {
    readonly_access_arn = var.readonly_access_arn
  }
}

data "template_file" "allow_assume_aws_nuke_access" {
  count    = (var.aws_nuke_access_arn != null) ? 1 : 0
  template = file("${path.module}/policies/allow_assume_aws_nuke_access.json.tpl")

  vars = {
    aws_nuke_access_arn = var.aws_nuke_access_arn
  }
}

data "template_file" "allow_assume_ci_admin_access" {
  template = file("${path.module}/policies/allow_assume_ci_admin_access.json.tpl")

  vars = {
    ci_admin_access_arn = var.ci_admin_access_arn
  }
}

data "aws_iam_group" "nuke_user_group" {
  count      = (var.aws_nuke_access_arn != null) ? 1 : 0
  group_name = "AwsNuke"
}

data "aws_iam_group" "ci_admin_user_group" {
  group_name = "CiAdmin"
}
