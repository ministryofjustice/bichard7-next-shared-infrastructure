resource "aws_iam_user" "csoc" {
  name = "csoc-xsiam"
  path = "/csoc-xsiam/"
}

resource "aws_iam_user_policy" "csoc_user" {
  name = "AllowXSIAMToAccessSQSQueue"
  user = aws_iam_user.csoc.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCSOCSQSAccess",
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ],
        Resource = aws_sqs_queue.csoc_queue.arn
      }
    ]
  })
}

resource "aws_kms_key" "csoc_sqs_key" {
  description             = "CSOC queue encryption key"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow SQS to encrypt messages",
        Effect = "Allow",
        Principal = {
          Service = "sqs.amazonaws.com",
          AWS     = data.aws_caller_identity.current.arn
        },
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow S3 to work with key",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow cloudwatch to work with key",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow CSOC to decrypt messages",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_user.csoc.arn
        },
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_kms_alias" "csoc_queue_encryption_key" {
  target_key_id = aws_kms_key.csoc_sqs_key.id
  name          = "alias/csoc-sqs"
}

resource "aws_sqs_queue" "csoc_queue" {
  name                      = "csoc-queue"
  message_retention_seconds = 14 * 86400
  receive_wait_time_seconds = 2
  kms_master_key_id         = aws_kms_key.csoc_sqs_key.key_id

  tags = var.tags
}

resource "aws_s3_bucket_notification" "sqs_notification" {
  bucket = data.aws_s3_bucket.csoc_logs.id

  queue {
    queue_arn     = aws_sqs_queue.csoc_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "AWSLogs/"
    filter_suffix = ".gz"
  }

}

resource "aws_sqs_queue_policy" "csoc_allow_cloudwatch" {
  queue_url = aws_sqs_queue.csoc_queue.url
  policy    = data.aws_iam_policy_document.send_to_csoc_sqs.json
}
