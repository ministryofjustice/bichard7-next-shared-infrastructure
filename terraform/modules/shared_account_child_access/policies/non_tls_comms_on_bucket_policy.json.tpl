{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyNonTLSComms",
      "Effect": "Deny",
      "Action": "s3:*",
      "Resource": [
        "${bucket_arn}",
        "${bucket_arn}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": {
        "AWS": "*"
      }
    }
  ]
}
