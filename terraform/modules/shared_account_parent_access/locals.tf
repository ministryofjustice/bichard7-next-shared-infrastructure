locals {
  allow_assume_aws_nuke_access_policy = templatefile(
    "${path.module}/policies/allow_assume_aws_nuke_access.json.tpl",
    {
      aws_nuke_access_arn = var.aws_nuke_access_arn
    }
  )
}