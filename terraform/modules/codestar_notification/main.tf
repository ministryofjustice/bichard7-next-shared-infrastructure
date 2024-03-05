resource "aws_codestarnotifications_notification_rule" "codebuild_notification_rule" {
  detail_type    = "BASIC"
  event_type_ids = var.event_type_ids

  name     = "${var.name}-notification"
  resource = var.notification_source_arn

  target {
    address = var.sns_notification_arn
  }

  tags = var.tags
}

resource "aws_iam_policy" "allow_codebuild_sns_kms" {
  name_prefix = "AllowCodebuildSNSAccess-${var.name}"
  policy      = templatefile("${path.module}/policies/kms.json.tpl", {
    sns_key_arn = var.sns_kms_key_arn
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "codebuild_sns_kms_policy_attachment" {
  policy_arn = aws_iam_policy.allow_codebuild_sns_kms.arn
  role       = var.ci_cd_service_role_name
}
