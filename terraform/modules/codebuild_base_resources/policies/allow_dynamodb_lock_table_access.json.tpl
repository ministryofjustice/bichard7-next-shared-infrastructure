{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "dynamodb:DeleteItem",
            "dynamodb:DescribeTable",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",
            "dynamodb:DescribeTimeToLive"
        ],
        "Resource": [
            "${lock_table_arn}"
        ]
      }
    ]
  }
