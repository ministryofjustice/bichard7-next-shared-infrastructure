{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowCodebuildSnsKmsKey",
        "Effect": "Allow",
        "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:DescribeKey",
            "kms:GetPublicKey"
        ],
        "Resource": "${sns_key_arn}"
      }
    ]
  }
