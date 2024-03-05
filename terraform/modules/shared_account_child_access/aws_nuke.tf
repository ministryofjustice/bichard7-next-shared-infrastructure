resource "aws_iam_role" "assume_aws_nuke_access" {
  count                = (var.create_nuke_user == true) ? 1 : 0
  name                 = "Bichard7-Aws-Nuke-Access"
  max_session_duration = 10800
  assume_role_policy = templatefile("${path.module}/policies/${local.no_mfa_access_template}", {
    parent_account_id = var.root_account_id
    excluded_arns     = jsonencode(var.denied_user_arns)
    user_role         = "aws-nuke"
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "nuke_policy_1" {
  count  = (var.create_nuke_user == true) ? 1 : 0
  name   = "NukePolicy1"
  role   = aws_iam_role.assume_aws_nuke_access[count.index].id
  policy = file("${path.module}/policies/allow_nuke_part1.json")
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "nuke_policy_2" {
  count  = (var.create_nuke_user == true) ? 1 : 0
  name   = "NukePolicy2"
  role   = aws_iam_role.assume_aws_nuke_access[count.index].id
  policy = file("${path.module}/policies/allow_nuke_part2.json")
}

resource "aws_iam_role_policy" "nuke_policy_3" {
  count  = (var.create_nuke_user == true) ? 1 : 0
  name   = "NukePolicy3"
  role   = aws_iam_role.assume_aws_nuke_access[count.index].id
  policy = file("${path.module}/policies/allow_nuke_part3.json")
}

resource "aws_iam_role_policy" "nuke_policy_4" {
  count  = (var.create_nuke_user == true) ? 1 : 0
  name   = "NukePolicy4"
  role   = aws_iam_role.assume_aws_nuke_access[count.index].id
  policy = file("${path.module}/policies/allow_nuke_part4.json")
}
