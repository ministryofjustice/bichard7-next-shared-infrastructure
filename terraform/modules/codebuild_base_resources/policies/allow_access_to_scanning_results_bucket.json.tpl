{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "ListObjectsInBucket",
              "Effect": "Allow",
              "Action": [
                  "s3:ListBucket"
              ],
              "Resource": "${scanning_bucket_arn}",
              "Principal": {
                "AWS": ${allowed_account_arns}
              }
          },
          {
              "Sid": "AllObjectActions",
              "Effect": "Allow",
              "Action": [
                "s3:*Object",
                "s3:*ObjectAcl"
              ],
              "Resource": ["${scanning_bucket_arn}/*"],
               "Principal": {
                "AWS": ${allowed_account_arns}
              }
          },
          {
              "Sid": "AllActions",
              "Effect": "Allow",
              "Action": "s3:*",
              "Resource": [
                  "${scanning_bucket_arn}/*",
                  "${scanning_bucket_arn}"
              ],
             "Principal": {
              "AWS": [
                "arn:aws:iam::${account_id}:root",
                "${ci_user_arn}"
              ]
            }
          }
      ]
  }
