{
  "Version": "2012-10-17",
  "Statement": [
     {
      "Sid": "AllowAccountSNSAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "${sns_topic_arn}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${account_id}"
        }
      }
    },
    {
      "Sid": "AllowAwsEventsPublish",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "events.amazonaws.com",
          "codestar-notifications.amazonaws.com",
          "codebuild.amazonaws.com",
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "SNS:Publish",
      "Resource": "${sns_topic_arn}"
    }
  ]
}
