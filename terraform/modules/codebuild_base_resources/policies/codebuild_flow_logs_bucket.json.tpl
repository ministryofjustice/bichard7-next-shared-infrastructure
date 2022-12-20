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
          "Bool" : {
            "aws:SecureTransport": false
          }
        },
        "Principal": {
          "AWS": "*"
        }
      }
    ]
  }
