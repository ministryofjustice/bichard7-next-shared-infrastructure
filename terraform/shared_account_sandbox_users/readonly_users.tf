## Gurpinder Basi
data "aws_ssm_parameter" "gurpinder_basi" {
  name = "/users/gurpinder_basi"
}

resource "aws_iam_user" "gurpinder_basi" {
  name = data.aws_ssm_parameter.gurpinder_basi.value

  tags = module.label.tags
}

resource "aws_iam_user_group_membership" "gurpinder_basi" {
  groups = [
    data.aws_iam_group.readonly_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.gurpinder_basi.name
}
