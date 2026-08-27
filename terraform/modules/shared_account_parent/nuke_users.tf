resource "aws_iam_user" "nuke_user" {
  count = (var.create_nuke_user == true) ? 1 : 0
  name  = data.aws_ssm_parameter.aws_nuke_user[count.index].value
  path  = "/system/"

  tags = merge(
    var.tags,
    {
      "user-role" = "aws-nuke"
    }
  )
}

# tfsec:ignore:aws-iam-enforce-group-mfa
resource "aws_iam_group" "aws_nuke_group" {
  count = (var.create_nuke_user == true) ? 1 : 0
  name  = "AwsNuke"
}

resource "aws_iam_user_group_membership" "nuke_user" {
  count = (var.create_nuke_user == true) ? 1 : 0

  groups = [
    aws_iam_group.aws_nuke_group[count.index].name
  ]
  user = aws_iam_user.nuke_user[count.index].name
}

resource "aws_iam_access_key" "nuke_user_key" {
  count = (var.create_nuke_user == true) ? 1 : 0
  user  = aws_iam_user.nuke_user[count.index].name
}

resource "aws_ssm_parameter" "nuke_user_access_key_id" {
  count = (var.create_nuke_user == true) ? 1 : 0
  name  = "/nuke/user/access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.nuke_user_key[count.index].id

  tags = var.tags
}

resource "aws_ssm_parameter" "nuke_user_secret_access_key" {
  count = (var.create_nuke_user == true) ? 1 : 0
  name  = "/nuke/user/secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.nuke_user_key[count.index].secret

  tags = var.tags
}

data "aws_iam_policy_document" "route53_nuke_permissions" {
  count = (var.create_nuke_user == true) ? 1 : 0

  statement {
    sid    = "Route53CleanupAccess"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:GetHostedZone",
      "route53:GetChange"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "route53_nuke" {
  count = (var.create_nuke_user == true) ? 1 : 0

  name        = "Route53RecordManagementPolicy"
  description = "Allows listing and deleting DNS record sets in Route 53"
  policy      = data.aws_iam_policy_document.route53_nuke_permissions[0].json
}

resource "aws_iam_group_policy_attachment" "nuke_group_policy_attach" {
  count = (var.create_nuke_user == true) ? 1 : 0

  group      = aws_iam_group.aws_nuke_group[0].name
  policy_arn = aws_iam_policy.route53_nuke[0].arn
}
