{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyNonTLSComms",
      "Effect": "Deny",
      "Action": "s3:*",
      "Resource": [
        "${codebuild_flow_logs_bucket_arn}",
        "${codebuild_flow_logs_bucket_arn}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": false
        }
      },
      "Principal": {
        "AWS": "*"
      }
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${codebuild_flow_logs_bucket_arn}/AWSLogs/${account_id}/*",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "${account_id}",
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheckAndListBucket",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:ListBucket",
      "Resource": "${codebuild_flow_logs_bucket_arn}",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "${account_id}",
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
