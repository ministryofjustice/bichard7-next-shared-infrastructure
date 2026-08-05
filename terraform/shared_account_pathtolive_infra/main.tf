module "tag_vars" {
  source = "../modules/tag_vars"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  # namespace, environment, stage, name, attributes
  namespace   = "${lower(module.tag_vars.business_unit)}-${replace(module.tag_vars.application, "-", "")}"
  name        = "pathtolive-bootstrap"
  environment = terraform.workspace

  tags = {
    "business-unit"    = module.tag_vars.business_unit
    "application"      = module.tag_vars.application
    "is-production"    = true
    "environment-name" = "pathtolive-shared-infra"
    "account-name"     = "bichard7-shared"
    "provisioned-by"   = "shared_account_pathtolive_infra code see make shared-account-pathtolive-infra in Makefile"
    "source-code"      = "https://github.com/ministryofjustice/bichard7-next-shared-infrastructure/tree/main/shared_terraform/shared_account_pathtolive_infra"
    "owner"            = module.tag_vars.owner_email
    "region"           = data.aws_region.current_region.name
  }
}

module "aws_logs" {
  source            = "trussworks/logs/aws"
  version           = "16.2.0"
  s3_bucket_name    = "${module.label.name}-aws-logs"
  versioning_status = "Enabled"

  tags = module.label.tags
}

resource "aws_s3_bucket_policy" "aws_logs_policy" {
  bucket = module.aws_logs.aws_logs_bucket
  policy = templatefile("${path.module}/policies/aws_logs_bucket_policy.json.tpl", {
    aws_logs_bucket_arn = module.aws_logs.bucket_arn
  })
}

data "aws_iam_policy_document" "csoc_s3_replication_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "csoc_s3_replication" {
  name               = "${module.label.name}-s3-replication-role"
  assume_role_policy = data.aws_iam_policy_document.csoc_s3_replication_assume_role.json
  tags               = module.label.tags
}

resource "aws_iam_policy" "csoc_s3_replication" {
  name = "${module.label.name}-s3-replication-policy"
  policy = templatefile("${path.module}/policies/s3_replication_iam_policy.json.tpl", {
    aws_logs_bucket_arn = module.aws_logs.bucket_arn
    parent_bucket_arn   = local.parent_bucket_arn
  })
}

resource "aws_iam_role_policy_attachment" "s3_replication" {
  role       = aws_iam_role.csoc_s3_replication.name
  policy_arn = aws_iam_policy.csoc_s3_replication.arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_iam_role_policy_attachment.s3_replication]

  bucket = module.aws_logs.aws_logs_bucket
  role   = aws_iam_role.csoc_s3_replication.arn

  rule {
    id     = "replicate-all-to-parent"
    status = "Enabled"

    destination {
      bucket  = local.parent_bucket_arn
      account = local.parent_account_id

      access_control_translation {
        owner = "Destination"
      }
    }
  }
}
