{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "IamInstanceProfile",
      "Effect": "Deny",
      "Action": [
        "iam:AttachRolePolicy"
      ],
      "Resource": [
        "arn:aws:iam::${account_id}:role/Bichard7-CI-Access"
      ]
    }
  ]
}
