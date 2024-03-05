data "aws_iam_group" "nuke_user_group" {
  count      = (var.aws_nuke_access_arn != null) ? 1 : 0
  group_name = "AwsNuke"
}

data "aws_iam_group" "ci_admin_user_group" {
  group_name = "CiAdmin"
}
