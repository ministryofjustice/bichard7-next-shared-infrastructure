{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SourceBucketRead",
      "Effect": "Allow",
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Resource": "${aws_logs_bucket_arn}"
    },
    {
      "Sid": "SourceObjectsRead",
      "Effect": "Allow",
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging"
      ],
      "Resource": "${aws_logs_bucket_arn}/*"
    },
    {
      "Sid": "DestinationObjectsWrite",
      "Effect": "Allow",
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ],
      "Resource": "${parent_bucket_arn}/*"
    }
  ]
}
