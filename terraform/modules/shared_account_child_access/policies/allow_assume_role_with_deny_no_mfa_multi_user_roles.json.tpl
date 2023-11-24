{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${parent_account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "ArnNotEquals" : {
          "aws:PrincipalArn" : ${excluded_arns}
        },
        "StringEquals" : {
          "aws:PrincipalTag/user-role": "${user_role}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${parent_account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "ArnNotEquals" : {
          "aws:PrincipalArn" : ${excluded_arns}
        },
        "StringEquals" : {
          "aws:PrincipalTag/user-role": "${admin_user_role}"
        }
      }
    }
  ]
}
