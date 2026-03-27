resource "aws_iam_openid_connect_provider" "github_shared_infra" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_policy" "iam_read_only_audit" {
  name        = "GitHubIAMKeyAuditPolicy"
  description = "Allows GitHub Actions to list IAM users and their access keys."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListUsers",
          "iam:ListAccessKeys",
          "iam:GetAccessKeyLastUsed"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "github_oidc_role" {
  name = "github-actions-iam-access-key-auditor"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_shared_infra.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${local.github_repo}:ref:refs/heads/*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "audit_attach" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.iam_read_only_audit.arn
}
