{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": ${buckets}
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": ${bucket_contents}
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:eu-west-2:${root_account_id}:table/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:UpdateAssumeRolePolicy",
        "iam:GetPolicyVersion",
        "iam:ListRoleTags",
        "iam:DeleteGroup",
        "iam:UpdateGroup",
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DetachRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:DetachGroupPolicy",
        "iam:ListRolePolicies",
        "iam:DetachUserPolicy",
        "iam:PutGroupPolicy",
        "iam:GetRole",
        "iam:CreateGroup",
        "iam:GetPolicy",
        "iam:UpdateUser",
        "iam:ListEntitiesForPolicy",
        "iam:DeleteUserPolicy",
        "iam:AttachUserPolicy",
        "iam:DeleteRole",
        "iam:UpdateRoleDescription",
        "iam:GetUserPolicy",
        "iam:ListGroupsForUser",
        "iam:GetGroupPolicy",
        "iam:GetRolePolicy",
        "iam:UntagRole",
        "iam:TagRole",
        "iam:DeletePolicy",
        "iam:CreateUser",
        "iam:GetGroup",
        "iam:PassRole",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup",
        "iam:DeleteRolePolicy",
        "iam:ListAttachedUserPolicies",
        "iam:ListAttachedGroupPolicies",
        "iam:CreatePolicyVersion",
        "iam:ListGroupPolicies",
        "iam:DeleteUser",
        "iam:ListUserPolicies",
        "iam:TagUser",
        "iam:CreatePolicy",
        "iam:UntagUser",
        "iam:ListPolicyVersions",
        "iam:AttachGroupPolicy",
        "iam:PutUserPolicy",
        "iam:UpdateRole",
        "iam:GetUser",
        "iam:DeleteGroupPolicy",
        "iam:GetLoginProfile",
        "iam:DeletePolicyVersion",
        "iam:SetDefaultPolicyVersion",
        "iam:ListUserTags",
        "iam:ListInstanceProfilesForRole",
        "iam:GetInstanceProfile",
        "iam:ListInstanceProfiles"
      ],
      "Resource": [
        "arn:aws:iam::${root_account_id}:policy/*",
        "arn:aws:iam::${root_account_id}:user/*",
        "arn:aws:iam::${root_account_id}:group/*",
        "arn:aws:iam::${root_account_id}:instance-profile/*",
        "arn:aws:iam::${root_account_id}:role/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:EnableKey",
        "kms:GetPublicKey",
        "kms:Decrypt",
        "kms:ListKeyPolicies",
        "kms:UpdateKeyDescription",
        "kms:PutKeyPolicy",
        "kms:GetKeyPolicy",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:ListResourceTags",
        "kms:GenerateDataKeyPairWithoutPlaintext",
        "kms:DisableKey",
        "kms:GenerateDataKeyPair",
        "kms:ReEncryptFrom",
        "kms:UpdateAlias",
        "kms:Encrypt",
        "kms:GenerateDataKey",
        "kms:CreateAlias",
        "kms:ReEncryptTo",
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:ListRetirableGrants",
        "kms:RetireGrant",
        "kms:RevokeGrant"
      ],
      "Resource": [
        "arn:aws:kms:*:${root_account_id}:key/*",
        "arn:aws:kms:*:${root_account_id}:alias/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:ListKeys",
        "kms:GenerateRandom",
        "kms:ListAliases",
        "kms:CreateKey",
        "ecr:GetRegistryPolicy",
        "ecr:DescribeRegistry",
        "ecr:GetAuthorizationToken",
        "ecr:DeleteRegistryPolicy",
        "ecr:PutRegistryPolicy",
        "ecr:PutReplicationConfiguration",
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances",
        "ec2:AssociateIamInstanceProfile",
        "ec2:DescribeIamInstanceProfileAssociations",
        "ec2:DisassociateIamInstanceProfile",
        "ec2:ReplaceIamInstanceProfileAssociation",
        "ec2:CreateRouteTable",
        "ec2:CreateRoute",
        "ec2:AssociateRouteTable",
        "ec2:ModifyVpcAttribute",
        "ec2:ModifySecurityGroupRules",
        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
        "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
        "ec2:DeleteRouteTable",
        "ec2:ReplaceRoute",
        "ec2:DeleteRoute"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ecr:*",
      "Resource": "arn:aws:ecr:*:${root_account_id}:repository/*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "route53:ListReusableDelegationSets",
          "route53:ListTrafficPolicyInstances",
          "route53:GetTrafficPolicyInstanceCount",
          "route53:CreateReusableDelegationSet",
          "route53:CreateTrafficPolicy",
          "route53:TestDNSAnswer",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:GetAccountLimit",
          "route53:GetCheckerIpRanges",
          "route53:ListHealthChecks",
          "route53:CreateHealthCheck",
          "route53:ListTrafficPolicies",
          "route53:GetGeoLocation",
          "route53:ListGeoLocations",
          "route53:GetHostedZoneCount",
          "route53:GetHealthCheckCount",
          "sns:CreateTopic",
          "sns:GetTopicAttributes",
          "sns:List*",
          "sns:Publish",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "events:*",
          "iam:ListPolicies",
          "iam:ListPoliciesGrantingServiceAccess",
          "iam:ListRoles",
          "iam:ListUsers",
          "iam:ListGroups"
      ],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "route53:*",
        "Resource": [
            "arn:aws:route53:::hostedzone/*",
            "arn:aws:route53:::trafficpolicyinstance/*",
            "arn:aws:route53:::healthcheck/*",
            "arn:aws:route53:::change/*",
            "arn:aws:ec2:*:${root_account_id}:vpc/*",
            "arn:aws:route53:::trafficpolicy/*",
            "arn:aws:route53:::queryloggingconfig/*",
            "arn:aws:route53:::delegationset/*"
        ]
    },
    {
     "Effect":"Allow",
     "Action": [
        "ec2:AcceptVpcPeeringConnection",
        "ec2:ModifyVpcPeeringConnectionOptions"
      ],
     "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codepipeline:Get*",
        "codepipeline:List*"
      ],
      "Resource": "arn:aws:codepipeline:*:${root_account_id}:*"
    },
    {
      "Effect": "Deny",
      "Action": "iam:AttachRolePolicy",
      "Resource": "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  ]
}
