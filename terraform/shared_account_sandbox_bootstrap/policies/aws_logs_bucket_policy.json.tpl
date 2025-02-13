{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "enforce-tls-requests-only",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": [
        "${aws_logs_bucket_arn}/*",
        "${aws_logs_bucket_arn}"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    },
    {
      "Sid": "aws-s3-write",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_logs_bucket_arn}/*"
    }
  ]
}
