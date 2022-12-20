module "shared_account_user_access" {
  source = "../modules/shared_account_parent"

  buckets = [
    "arn:aws:s3:::${local.remote_bucket_name}",
    "arn:aws:s3:::${module.aws_logs.aws_logs_bucket}"
  ]

  create_nuke_user = true

  tags = module.label.tags
}
