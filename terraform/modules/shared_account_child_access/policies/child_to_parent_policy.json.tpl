{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RemoteSourceReadWrite",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${bucket_name}",
        "arn:aws:s3:::${logging_bucket}",
        "arn:aws:dynamodb:eu-west-2:${parent_account_id}:table/*"
      ]
    },
    {
      "Sid": "S3LoggingReadWrite",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::${logging_bucket}/*"
      ]
    },
    {
      "Sid": "ECRReadAccessToParent",
      "Effect": "Allow",
      "Action": [
        "ecr:DescribeImageScanFindings",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:ListTagsForResource",
        "ecr:ListImages",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetRepositoryPolicy",
        "ecr:GetLifecyclePolicy"
      ],
      "Resource": "arn:aws:ecr:eu-west-2:${parent_account_id}:repository/*"
    },
    {
      "Sid": "ECRAuthAndList",
      "Effect": "Allow",
      "Action": [
        "ecr:GetRegistryPolicy",
        "ecr:DescribeRegistry",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    },
    {
      "Sid": "RemoteSourceList",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:GetBucketVersioning",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl",
        "s3:ListBucketVersions",
        "s3:ListBucket"
      ],
      "Resource": [
          "arn:aws:s3:::${bucket_name}/*",
          "arn:aws:s3:::${bucket_name}"
      ]
    }
  ]
}
