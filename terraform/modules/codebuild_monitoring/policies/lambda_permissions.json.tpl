{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetProjects",
        "codebuild:BatchGetBuildBatches",
        "cloudwatch:ListTagsForResource",
        "codebuild:ListBuildBatchesForProject",
        "codebuild:ListBuildsForProject",
        "codebuild:BatchGetBuilds"
      ],
      "Resource": [
        "arn:aws:cloudwatch:*:${account_id}:insight-rule/*",
        "arn:aws:cloudwatch:*:${account_id}:alarm:*",
        "arn:aws:codebuild:*:${account_id}:project/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:ListBuildBatches",
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricData",
        "cloudwatch:ListMetricStreams",
        "codebuild:ListBuilds",
        "codebuild:ListProjects",
        "cloudwatch:ListMetrics"
      ],
      "Resource": "*"
    }
  ]
}
