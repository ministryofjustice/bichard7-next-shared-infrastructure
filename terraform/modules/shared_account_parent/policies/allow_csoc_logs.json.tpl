{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${bucket_arn}",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": [
            "415925668545",
            "071486367987",
            "581823340673"
          ]
        }
      }
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": [
        "${bucket_arn}/AWSLogs/415925668545/*",
        "${bucket_arn}/AWSLogs/071486367987/*",
        "${bucket_arn}/AWSLogs/581823340673/*",
        "${bucket_arn}/s3-data-events/AWSLogs/415925668545/*",
        "${bucket_arn}/csoc-vpc-flow-logs/AWSLogs/415925668545/*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": [
            "415925668545",
            "071486367987",
            "581823340673"
          ],
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${bucket_arn}/csoc-vpc-flow-logs/AWSLogs/415925668545/*",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "415925668545",
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": [
        "s3:GetBucketAcl",
        "s3:ListBucket"
      ],
      "Resource": "${bucket_arn}",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "415925668545"
        }
      }
    },
    {
      "Sid": "AllowXSIAMRead",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::497078235711:user/csoc-xsiam/csoc-xsiam"
      },
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${bucket_arn}",
        "${bucket_arn}/*"
      ]
    },
    {
      "Sid": "AllowCrossAccountReplicationBucket",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "s3:GetBucketVersioning"
      ],
      "Resource": "${bucket_arn}",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": [
            "415925668545",
            "071486367987",
            "581823340673"
          ]
        }
      }
    },
    {
      "Sid": "AllowCrossAccountReplicationObjects",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ],
      "Resource": "${bucket_arn}/*",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": [
            "415925668545",
            "071486367987",
            "581823340673"
          ]
        }
      }
    }
  ]
}
