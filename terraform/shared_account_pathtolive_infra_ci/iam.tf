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
# This is currently set to Count 0 as the PAAS has certain policies in place that
# prevent us from adding role policies, we need them to lift this temporarily to apply the role policy, when this is done,
# the count can be removed and the role policy applied
resource "aws_iam_role_policy" "allow_production_codebuild_bucket" {
  count = 0
  name  = "AllCodeBuildBucketAccess"
  role  = "Bichard7-CI-Access"

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

resource "aws_iam_group" "github_actions" {
  name = "GitHubActions"
  path = "/groups/"
}

resource "aws_iam_user_group_membership" "github_actions_user_membership" {
  user   = "github-actions"
  groups = [aws_iam_group.github_actions.name]
}

data "aws_iam_policy_document" "ecr_pull_policy" {
  statement {
    sid       = "ECRAuthToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "ECRPullActions"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      module.codebuild_docker_resources.amazon_linux_2023.arn,
      module.codebuild_docker_resources.nodejs_24_2023,
      module.codebuild_docker_resources.nginx_nodejs_24_2023_supervisord
    ]
  }
}

resource "aws_iam_policy" "ecr_pull" {
  name        = "ECRImagePullPolicy"
  description = "Grants minimal permissions to pull images from specific ECR repositories"
  policy      = data.aws_iam_policy_document.ecr_pull_policy.json
}

resource "aws_iam_group_policy_attachment" "attach_ecr_pull" {
  group      = aws_iam_group.github_actions.name
  policy_arn = aws_iam_policy.ecr_pull.arn
}
