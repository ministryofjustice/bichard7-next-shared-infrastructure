{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:ListCuratedEnvironmentImages",
        "codebuild:ListReportGroups",
        "codebuild:ListSourceCredentials",
        "codebuild:ListRepositories",
        "codebuild:ListSharedProjects",
        "codebuild:ListBuildBatches",
        "codebuild:ListSharedReportGroups",
        "codebuild:ImportSourceCredentials",
        "codebuild:ListReports",
        "codebuild:ListBuilds",
        "codebuild:DeleteOAuthToken",
        "codebuild:ListProjects",
        "codebuild:DeleteSourceCredentials",
        "codebuild:PersistOAuthToken",
        "codebuild:ListConnectedOAuthAccounts"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "codebuild:*",
      "Resource": [
        "arn:aws:codebuild:*:${root_account_id}:report-group/*",
        "arn:aws:codebuild:*:${root_account_id}:project/*"
      ]
    }
  ]
}
