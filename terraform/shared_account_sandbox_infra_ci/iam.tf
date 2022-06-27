# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_sandbox_a_codebuild_bucket" {
  for_each = toset(["Bichard7-CI-Access", "Bichard7-Aws-Nuke-Access"])
  name     = "AllCodeBuildBucketAccess"
  role     = each.key

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

  provider = aws.sandbox_a
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_sandbox_b_codebuild_bucket" {
  for_each = toset(["Bichard7-CI-Access", "Bichard7-Aws-Nuke-Access"])
  name     = "AllCodeBuildBucketAccess"
  role     = each.key

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

  provider = aws.sandbox_b
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "allow_sandbox_c_codebuild_bucket" {
  for_each = toset(["Bichard7-CI-Access", "Bichard7-Aws-Nuke-Access"])
  name     = "AllCodeBuildBucketAccess"
  role     = each.key

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

  provider = aws.sandbox_c
}

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
resource "aws_iam_user_policy" "allow_ci_cloudfront" {
  name = "CloudfrontAccess"
  user = "cjse.ci"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListCloudfrontDistributions",
        "Effect": "Allow",
        "Action": ["cloudfront:ListDistributions"],
        "Resource": ["*"]
      }
    ]
  }
  EOF
}
