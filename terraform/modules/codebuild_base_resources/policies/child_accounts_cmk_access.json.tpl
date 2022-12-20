{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow an external account to use this CMK",
      "Effect": "Allow",
      "Principal": {
        "AWS": ${child_accounts}
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },{
      "Sid":  "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${account_id}:root"
      },
      "Action": [
        "kms:*"
       ],
      "Resource": "*"
    }
  ]
}
