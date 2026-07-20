resource "aws_iam_user" "csoc" {
  count = var.is_path_to_live ? 1 : 0

  name = "csoc-xsiam"
  path = "/csoc-xsiam/"
}

resource "aws_iam_user_policy" "csoc_user" {
  count = var.is_path_to_live ? 1 : 0

  name = "AllowXSIAMToAccessSQSQueue"
  user = aws_iam_user.csoc[0].name

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
        Resource = aws_sqs_queue.csoc_queue[0].arn
      },
      {
        Sid : "AllowXSIAMToReadLogs",
        Effect : "Allow",
        Action : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource : [
          "arn:aws:s3:::moj-bichard7-production-logs",
          "arn:aws:s3:::moj-bichard7-production-logs/*"
        ]
      },
      {
        Sid : "AllowDecryptCloudtrailLogs",
        Effect : "Allow",
        Action : [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource : [aws_kms_key.csoc_sqs_key[0].arn]
      },
      {
        Sid : "AllowAccessToChildKMSKey"
        Effect : "Allow",
        Action : "kms:Decrypt",
        Resource : "arn:aws:kms:eu-west-2:415925668545:key/ba38cc77-49a8-46d0-9cbc-97b3a33f95fb"
      }
    ]
  })
}

resource "aws_kms_key" "csoc_sqs_key" {
  count = var.is_path_to_live ? 1 : 0

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
          AWS = aws_iam_user.csoc[0].arn
        },
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_kms_alias" "csoc_queue_encryption_key" {
  count = var.is_path_to_live ? 1 : 0

  target_key_id = aws_kms_key.csoc_sqs_key[0].id
  name          = "alias/csoc-sqs"
}

resource "aws_sqs_queue" "csoc_queue" {
  count = var.is_path_to_live ? 1 : 0

  name                      = "csoc-queue"
  message_retention_seconds = 14 * 86400
  receive_wait_time_seconds = 2
  kms_master_key_id         = aws_kms_key.csoc_sqs_key[0].key_id

  tags = var.tags
}

resource "aws_s3_bucket_notification" "sqs_notification" {
  count = var.is_path_to_live ? 1 : 0

  bucket = data.aws_s3_bucket.csoc_logs[0].id

  queue {
    queue_arn     = aws_sqs_queue.csoc_queue[0].arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "AWSLogs/"
    filter_suffix = ".gz"
  }

}

resource "aws_sqs_queue_policy" "csoc_allow_cloudwatch" {
  count = var.is_path_to_live ? 1 : 0

  queue_url = aws_sqs_queue.csoc_queue[0].url
  policy    = data.aws_iam_policy_document.send_to_csoc_sqs.json
}
