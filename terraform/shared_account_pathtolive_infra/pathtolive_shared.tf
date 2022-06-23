module "shared_account_user_access" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent?ref=upgrade-aws-provider"
  tags   = module.label.tags

  buckets = [
    "arn:aws:s3:::${local.remote_bucket_name}",
    "arn:aws:s3:::${module.aws_logs.aws_logs_bucket}"
  ]

  providers = {
    aws = aws.shared
  }
}
