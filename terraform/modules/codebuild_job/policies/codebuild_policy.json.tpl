{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": ${codebuild_logs}
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketAcl",
        "s3:GetObjectAcl",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:List*",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:*Tagging"
      ],
      "Resource": [
        "${codebuild_bucket}",
        "${codebuild_bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:Describe*",
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "*"
    }
  ]
}
