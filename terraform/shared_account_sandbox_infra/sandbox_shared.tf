module "shared_account_user_access" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent?ref=upgrade-aws-provider"

  buckets = [
    "arn:aws:s3:::${local.remote_bucket_name}",
    "arn:aws:s3:::${module.aws_logs.aws_logs_bucket}"
  ]

  create_nuke_user = true

  tags = module.label.tags
}
