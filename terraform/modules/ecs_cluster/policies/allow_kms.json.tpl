{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:GetPublicKey",
        "kms:ListKeyPolicies",
        "kms:UntagResource",
        "kms:ListRetirableGrants",
        "kms:PutKeyPolicy",
        "kms:GetKeyPolicy",
        "kms:ListResourceTags",
        "kms:RetireGrant",
        "kms:ListGrants",
        "kms:GetParametersForImport",
        "kms:TagResource",
        "kms:GetKeyRotationStatus",
        "kms:RevokeGrant",
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:GenerateDataKey"
      ],
      "Resource": "arn:aws:kms:eu-west-2:${account_id}:key/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:DescribeCustomKeyStores",
        "kms:ListKeys"
      ],
      "Resource": "*"
    }
  ]
}
