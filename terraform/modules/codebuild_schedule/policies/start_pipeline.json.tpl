{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:StartBuild*"
            ],
            "Resource": [
                "${codebuild_arn}"
            ]
        }
    ]
}
