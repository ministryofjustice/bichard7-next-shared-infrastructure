# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_user_policy" "allow_ci_codebuild_bucket" {
  name = "AllCodeBuildBucketAccess"
  user = "cjse.ci"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}"]
      },
      {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}/*"]
      },
      {
        "Sid": "AllTaggingActions",
        "Effect": "Allow",
        "Action": "s3:*Tagging",
        "Resource": [
          "${module.codebuild_base_resources.codepipeline_bucket_arn}",
          "${module.codebuild_base_resources.codepipeline_bucket_arn}/*"
        ]
      }
    ]
  }
  EOF
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_integration_next_codebuild_bucket" {
  name = "AllCodeBuildBucketAccess"
  role = "Bichard7-CI-Access"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}"]
      },
      {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}/*"]
      },
      {
        "Sid": "AllTaggingActions",
        "Effect": "Allow",
        "Action": "s3:*Tagging",
        "Resource": [
          "${module.codebuild_base_resources.codepipeline_bucket_arn}",
          "${module.codebuild_base_resources.codepipeline_bucket_arn}/*"
        ]
      }
    ]
  }
  EOF

  provider = aws.integration_next
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_integration_baseline_codebuild_bucket" {
  name = "AllCodeBuildBucketAccess"
  role = "Bichard7-CI-Access"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}"]
      },
      {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}/*"]
      },
      {
        "Sid": "AllTaggingActions",
        "Effect": "Allow",
        "Action": "s3:*Tagging",
        "Resource": [
          "${module.codebuild_base_resources.codepipeline_bucket_arn}",
          "${module.codebuild_base_resources.codepipeline_bucket_arn}/*"
        ]
      }
    ]
  }
  EOF

  provider = aws.integration_baseline
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_qsolution_codebuild_bucket" {
  name = "AllCodeBuildBucketAccess"
  role = "Bichard7-CI-Access"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}"]
      },
      {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}/*"]
      },
      {
        "Sid": "AllTaggingActions",
        "Effect": "Allow",
        "Action": "s3:*Tagging",
        "Resource": [
          "${module.codebuild_base_resources.codepipeline_bucket_arn}",
          "${module.codebuild_base_resources.codepipeline_bucket_arn}/*"
        ]
      }
    ]
  }
  EOF

  provider = aws.qsolution
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_production_codebuild_bucket" {
  name = "AllCodeBuildBucketAccess"
  role = "Bichard7-CI-Access"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}"]
      },
      {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["${module.codebuild_base_resources.codepipeline_bucket_arn}/*"]
      },
      {
        "Sid": "AllTaggingActions",
        "Effect": "Allow",
        "Action": "s3:*Tagging",
        "Resource": [
          "${module.codebuild_base_resources.codepipeline_bucket_arn}",
          "${module.codebuild_base_resources.codepipeline_bucket_arn}/*"
        ]
      }
    ]
  }
  EOF

  provider = aws.production
}
