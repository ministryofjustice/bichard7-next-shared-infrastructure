{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetBucketAcl",
          "s3:ListBucketVersions",
          "s3:GetBucketVersioning",
          "s3:GetBucketPublicAccessBlock"
        ],
        "Resource": ["${bucket_arn}"],
        "Principal": {
          "AWS": ${allowed_principals}
        }
      },
      {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": [
          "s3:*Tagging",
          "s3:*Object",
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ],
        "Resource": ["${bucket_arn}/*"],
        "Principal": {
          "AWS": ${allowed_principals}
        }
      },
      {
        "Sid": "LambdaGet",
        "Effect": "Allow",
        "Action": [
          "s3:Get*",
          "s3:ListBucket",
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:ListBucketVersions",
          "s3:GetBucketVersioning"
        ],
        "Resource": [
          "${bucket_arn}/*",
          "${bucket_arn}"
        ],
        "Principal": {
          "AWS": ${allowed_principals_with_lambda}
        }
      },
      {
        "Sid": "AllActions",
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": ["${bucket_arn}/*"],
        "Principal": {
          "AWS": "arn:aws:iam::${account_id}:root"
        }
      },
      {
        "Sid": "AllActionsCodeBuild",
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
          "${bucket_arn}/*",
          "${bucket_arn}"
        ],
        "Principal": {
          "AWS": "${ci_user_arn}"
        }
      },
      {
          "Sid": "AWSCloudTrailRead",
          "Effect": "Allow",
          "Action": "s3:GetObject*",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Resource": [
            "${bucket_arn}/semaphores/*"
          ]
      },
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${bucket_arn}"
      },
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${bucket_arn}/AWSLogs/${account_id}/*",
          "Condition": {
              "StringEquals": {
                  "s3:x-amz-acl": "bucket-owner-full-control"
              }
          }
      }
    ]
  }
