resource "aws_iam_policy" "allow_assume_aws_nuke_access_role" {
  count = (var.aws_nuke_access_arn != null) ? 1 : 0
  name  = "Assume-AWS-Nuke-Access-on-${var.child_account_id}"
  policy = templatefile(
    "${path.module}/policies/allow_assume_aws_nuke_access.json.tpl",
    {
      aws_nuke_access_arn = var.aws_nuke_access_arn
    }
  )

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "aws_nuke_access_policy_attachment" {
  count      = (var.aws_nuke_access_arn != null) ? 1 : 0
  policy_arn = aws_iam_policy.allow_assume_aws_nuke_access_role[count.index].arn
  group      = data.aws_iam_group.nuke_user_group[count.index].group_name
}
