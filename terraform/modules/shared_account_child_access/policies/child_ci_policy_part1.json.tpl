{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "IamInstanceProfile",
      "Effect": "Allow",
      "Action": [
        "iam:CreateInstanceProfile",
        "iam:DeleteInstanceProfile",
        "iam:ListInstanceProfilesForRole",
        "iam:GetInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:ListInstanceProfiles",
        "iam:AddRoleToInstanceProfile",
        "iam:TagInstanceProfile",
        "iam:UntagInstanceProfile"
      ],
      "Resource": [
        "arn:aws:iam::${account_id}:instance-profile/*",
        "arn:aws:iam::${account_id}:role/*"
      ]
    },
    {
      "Sid": "IamManagePermissions",
      "Effect": "Allow",
      "Action": [
        "iam:*PolicyVersion",
        "iam:ListRoleTags",
        "iam:CreateRole",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:GetRole",
        "iam:GetPolicy",
        "iam:ListEntitiesForPolicy",
        "iam:DeleteRole",
        "iam:UpdateRoleDescription",
        "iam:GetGroupPolicy",
        "iam:UntagRole",
        "iam:TagRole",
        "iam:UntagUser",
        "iam:TagUser",
        "iam:DeletePolicy",
        "iam:PassRole",
        "iam:ListAttachedGroupPolicies",
        "iam:ListGroupPolicies",
        "iam:CreatePolicy",
        "iam:ListPolicyVersions",
        "iam:AttachGroupPolicy",
        "iam:UpdateRole",
        "iam:DeleteGroupPolicy",
        "iam:ListGroupsForUser",
        "iam:CreateUser",
        "iam:DeleteUser",
        "iam:UpdateUser",
        "iam:GetUser",
        "iam:DeleteAccessKey",
        "iam:GetUserPolicy",
        "iam:PutUserPolicy",
        "iam:DeleteUserPolicy",
        "iam:AttachUserPolicy",
        "iam:UpdateAccessKey",
        "iam:DetachUserPolicy",
        "iam:CreateAccessKey",
        "iam:ListAccessKeys",
        "iam:CreateServiceLinkedRole",
        "iam:CreateServiceSpecificCredential",
        "iam:DeleteServiceLinkedRole",
        "iam:DeleteServiceSpecificCredential",
        "iam:UpdateServiceSpecificCredential",
        "iam:ListAttachedUserPolicies",
        "iam:*ServerCertificate",
        "iam:*ServerCertificateTags",
        "iam:TagPolicy",
        "iam:UntagPolicy"
      ],
      "Resource": [
        "arn:aws:iam::${account_id}:policy/*",
        "arn:aws:iam::${account_id}:user/*",
        "arn:aws:iam::${account_id}:group/*",
        "arn:aws:iam::${account_id}:role/*",
        "arn:aws:iam::${account_id}:server-certificate/*"
      ]
    },
    {
      "Sid": "RolePolicies",
      "Effect": "Allow",
      "Action": [
        "iam:DetachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:GetRolePolicy"
      ],
      "Resource": [
        "arn:aws:iam::${account_id}:role/bichard-7-*",
        "arn:aws:iam::${account_id}:role/cjse-*",
        "arn:aws:iam::${account_id}:role/postfix-*",
        "arn:aws:iam::${account_id}:role/vpc-flow-logs-role-cjse-*",
        "arn:aws:iam::${account_id}:role/Bichard7-Administrator-Access",
        "arn:aws:iam::${account_id}:role/Bichard7-Aws-Nuke-Access",
        "arn:aws:iam::${account_id}:role/AllowQueryPNCConnection",
        "arn:aws:iam::${account_id}:policy/bichard-7-*",
        "arn:aws:iam::${account_id}:policy/cjse-*",
        "arn:aws:iam::${account_id}:policy/postfix-*",
        "arn:aws:iam::${account_id}:policy/vpc-flow-logs-role-cjse-*",
        "arn:aws:iam::${account_id}:policy/*-query-pnc-conn-lambda-manage-ec2-network-interfaces",
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      ]
    },
    {
      "Sid": "IamListPermissions",
      "Effect": "Allow",
      "Action": [
        "iam:ListPolicies",
        "iam:ListPoliciesGrantingServiceAccess",
        "iam:ListRoles",
        "iam:ListGroups",
        "iam:ListUsers",
        "iam:*ServerCertificates"
      ],
      "Resource": "*"
    },
    {
      "Sid": "KMSKeyManagement",
      "Effect": "Allow",
      "Action": [
        "kms:EnableKey",
        "kms:GetPublicKey",
        "kms:ImportKeyMaterial",
        "kms:Decrypt",
        "kms:UntagResource",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:Verify",
        "kms:ListResourceTags",
        "kms:CancelKeyDeletion",
        "kms:GenerateDataKeyPair",
        "kms:GetParametersForImport",
        "kms:TagResource",
        "kms:Encrypt",
        "kms:GetKeyRotationStatus",
        "kms:ScheduleKeyDeletion",
        "kms:ReEncryptTo",
        "kms:DescribeKey",
        "kms:Sign",
        "kms:EnableKeyRotation",
        "kms:ListKeyPolicies",
        "kms:UpdateKeyDescription",
        "kms:GetKeyPolicy",
        "kms:DeleteImportedKeyMaterial",
        "kms:GenerateDataKeyPairWithoutPlaintext",
        "kms:DisableKey",
        "kms:ReEncryptFrom",
        "kms:DisableKeyRotation",
        "kms:ListGrants",
        "kms:ListRetirableGrants",
        "kms:RevokeGrant",
        "kms:RetireGrant",
        "kms:CreateGrant",
        "kms:UpdateAlias",
        "kms:GenerateDataKey",
        "kms:CreateAlias",
        "kms:DeleteAlias"
      ],
      "Resource": [
        "arn:aws:kms:*:${account_id}:key/*",
        "arn:aws:kms:*:${account_id}:alias/*"
      ]
    },
    {
      "Sid": "KMSManagement",
      "Effect": "Allow",
      "Action": [
        "kms:ListKeys",
        "kms:GenerateRandom",
        "kms:ListAliases",
        "kms:CreateKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Lambda",
      "Effect": "Allow",
      "Action": [
        "lambda:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "LambdaLogs",
      "Effect": "Allow",
      "Action": [
        "logs:DescribeLogStreams",
        "logs:GetLogEvents",
        "logs:FilterLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    },
    {
      "Sid": "ECSReadWrite",
      "Effect": "Allow",
      "Action": [
        "ecs:PutAttributes",
        "ecs:ListAttributes",
        "ecs:UpdateContainerInstancesState",
        "ecs:StartTask",
        "ecs:RegisterContainerInstance",
        "ecs:DeleteAttributes",
        "ecs:DescribeTaskSets",
        "ecs:DeleteCapacityProvider",
        "ecs:SubmitAttachmentStateChanges",
        "ecs:Poll",
        "ecs:UpdateService",
        "ecs:DescribeCapacityProviders",
        "ecs:CreateService",
        "ecs:RunTask",
        "ecs:ListTasks",
        "ecs:StopTask",
        "ecs:DescribeServices",
        "ecs:SubmitContainerStateChange",
        "ecs:DescribeContainerInstances",
        "ecs:DeregisterContainerInstance",
        "ecs:TagResource",
        "ecs:DescribeTasks",
        "ecs:UntagResource",
        "ecs:PutClusterCapacityProviders",
        "ecs:UpdateTaskSet",
        "ecs:SubmitTaskStateChange",
        "ecs:UpdateClusterSettings",
        "ecs:DeleteService",
        "ecs:DeleteCluster",
        "ecs:DeleteTaskSet",
        "ecs:DescribeClusters",
        "ecs:ListTagsForResource",
        "ecs:StartTelemetrySession",
        "ecs:UpdateContainerAgent",
        "ecs:ListContainerInstances",
        "ecs:UpdateServicePrimaryTaskSet",
        "ecs:UpdateCluster"
      ],
      "Resource": [
        "arn:aws:ecs:*:${account_id}:*"
      ]
    },
    {
      "Sid": "ECSList",
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterTaskDefinition",
        "ecs:ListServices",
        "ecs:CreateCapacityProvider",
        "ecs:DiscoverPollEndpoint",
        "ecs:ListTaskDefinitionFamilies",
        "ecs:CreateCluster",
        "ecs:RegisterTaskDefinition",
        "ecs:ListTaskDefinitions",
        "ecs:DescribeTaskDefinition",
        "ecs:CreateTaskSet",
        "ecs:ListClusters",
        "ecs:ListTasks"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SQSListQueues",
      "Effect": "Allow",
      "Action": "sqs:ListQueues",
      "Resource": "*"
    },
    {
      "Sid": "SQS",
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:*:${account_id}:*"
    }
  ]
}
