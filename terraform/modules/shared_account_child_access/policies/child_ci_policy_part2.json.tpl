{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ElasticSearchReadWrite",
      "Effect": "Allow",
      "Action": [
        "es:ESHttpGet",
        "es:CreateElasticsearchDomain",
        "es:ListTags",
        "es:DescribeElasticsearchDomainConfig",
        "es:ESHttpDelete",
        "es:GetUpgradeHistory",
        "es:ESCrossClusterGet",
        "es:AddTags",
        "es:RemoveTags",
        "es:ESHttpHead",
        "es:DeleteElasticsearchDomain",
        "es:DescribeElasticsearchDomain",
        "es:UpgradeElasticsearchDomain",
        "es:UpdateElasticsearchDomainConfig",
        "es:ESHttpPost",
        "es:GetCompatibleElasticsearchVersions",
        "es:ESHttpPatch",
        "es:GetUpgradeStatus",
        "es:DescribeElasticsearchDomains",
        "es:ESHttpPut"
      ],
      "Resource": "arn:aws:es:*:${account_id}:domain/*"
    },
    {
      "Sid": "ElasticSearchList",
      "Effect": "Allow",
      "Action": [
        "es:DescribeReservedElasticsearchInstanceOfferings",
        "es:DescribeReservedElasticsearchInstances",
        "es:ListDomainNames",
        "es:ListElasticsearchInstanceTypeDetails",
        "es:ListElasticsearchInstanceTypes",
        "es:DescribeElasticsearchInstanceTypeLimits",
        "es:ListElasticsearchVersions"
      ],
      "Resource": "*"
    },
    {
      "Sid": "RDSListAndView",
      "Effect": "Allow",
      "Action": [
        "rds:CancelExportTask",
        "rds:DescribeDBEngineVersions",
        "rds:CrossRegionCommunication",
        "rds:DescribeExportTasks",
        "rds:StartExportTask",
        "rds:DescribeEngineDefaultParameters",
        "rds:DeleteDBInstanceAutomatedBackup",
        "rds:DescribeReservedDBInstancesOfferings",
        "rds:DescribeOrderableDBInstanceOptions",
        "rds:DescribeEngineDefaultClusterParameters",
        "rds:DescribeSourceRegions",
        "rds:CreateDBProxy",
        "rds:DescribeCertificates",
        "rds:DescribeEventCategories",
        "rds:DescribeAccountAttributes",
        "rds:DescribeEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudwatchAll",
      "Effect": "Allow",
      "Action": [
        "logs:DescribeQueries",
        "logs:GetLogRecord",
        "logs:PutDestinationPolicy",
        "logs:StopQuery",
        "logs:TestMetricFilter",
        "logs:DeleteDestination",
        "logs:GetLogDelivery",
        "logs:ListLogDeliveries",
        "logs:CreateLogDelivery",
        "logs:CreateLogGroup",
        "logs:DeleteResourcePolicy",
        "logs:PutResourcePolicy",
        "logs:DescribeExportTasks",
        "logs:GetQueryResults",
        "logs:UpdateLogDelivery",
        "logs:CancelExportTask",
        "logs:DeleteLogDelivery",
        "logs:PutDestination",
        "logs:PutSubscriptionFilter",
        "logs:DescribeResourcePolicies",
        "logs:DescribeDestinations",
        "events:*Rule",
        "events:*TagsForResource",
        "events:*Targets",
        "events:TagResource",
        "cloudtrail:*",
        "states:*StateMachine",
        "states:ListStateMachineVersions",
        "states:*TagsForResource",
        "states:TagResource"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudwatchLogGroups",
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "arn:aws:logs:*:${account_id}:log-group:*"
    },
    {
      "Sid": "CloudwatchLogStreams",
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "arn:aws:logs:*:${account_id}:log-group:*:log-stream:*"
    },
    {
      "Sid": "Route53Full",
      "Effect": "Allow",
      "Action": [
        "route53:*",
        "route53domains:*",
        "cloudfront:ListDistributions",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticbeanstalk:DescribeEnvironments",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetBucketWebsite",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeRegions",
        "ec2:CreateNetworkInterface",
        "ec2:CreateNetworkInterfacePermission",
        "ec2:DeleteNetworkInterface",
        "ec2:DeleteNetworkInterfacePermission",
        "ec2:DetachNetworkInterface",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeNetworkInterfacePermissions",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "sns:*",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:GetMetricStatistics"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Route53APIGatewayFull",
      "Effect": "Allow",
      "Action": "apigateway:GET",
      "Resource": "arn:aws:apigateway:*::/domainnames"
    },
    {
      "Effect": "Allow",
      "Action": "apigateway:*",
      "Resource": "arn:aws:apigateway:*::/*"
    },
    {
      "Sid": "Route53Resolver",
      "Effect": "Allow",
      "Action": [
        "route53resolver:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SSMReadWrite",
      "Effect": "Allow",
      "Action": [
        "ssm:PutParameter",
        "ssm:LabelParameterVersion",
        "ssm:DeleteParameter",
        "ssm:RemoveTagsFromResource",
        "ssm:GetParameterHistory",
        "ssm:AddTagsToResource",
        "ssm:ListTagsForResource",
        "ssm:GetParametersByPath",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "ssm:DeleteParameters"
      ],
      "Resource": [
        "arn:aws:ssm:*:${account_id}:document/*",
        "arn:aws:ssm:*:${account_id}:parameter/*",
        "arn:aws:ssm:*:${account_id}:patchbaseline/*",
        "arn:aws:ssm:*:${account_id}:maintenancewindow/*",
        "arn:aws:ssm:*:${account_id}:managed-instance/*"
      ]
    },
    {
      "Sid": "SSMList",
      "Effect": "Allow",
      "Action": "ssm:DescribeParameters",
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "elasticfilesystem:ModifyMountTargetSecurityGroups",
            "elasticfilesystem:CreateFileSystem",
            "elasticfilesystem:DescribeMountTargetSecurityGroups"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "elasticfilesystem:*",
        "Resource": [
            "arn:aws:elasticfilesystem:*:${account_id}:file-system/*",
            "arn:aws:elasticfilesystem:*:${account_id}:access-point/*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": "mq:*",
        "Resource": [
            "*"
        ]
    },
    {
      "Action": [
        "ses:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "*",
        "arn:aws:ses:*:${account_id}:*/*"
      ]
    },
    {
      "Sid": "Backup",
      "Effect": "Allow",
      "Action": [
          "backup:CreateBackupPlan",
          "backup:CreateBackupSelection",
          "backup:CreateBackupVault",
          "backup-storage:MountCapsule",
          "backup:DescribeBackupJob",
          "backup:DescribeBackupVault",
          "backup:DescribeProtectedResource",
          "backup:DescribeRecoveryPoint",
          "backup:ExportBackupPlanTemplate",
          "backup:GetBackupPlan",
          "backup:GetBackupSelection",
          "backup:ListBackupJobs",
          "backup:ListBackupPlans",
          "backup:ListBackupPlanTemplates",
          "backup:ListBackupPlanVersions",
          "backup:ListBackupSelections",
          "backup:ListBackupVaults",
          "backup:ListProtectedResources",
          "backup:ListRecoveryPointsByBackupVault",
          "backup:ListRecoveryPointsByResource",
          "backup:ListRestoreJobs",
          "backup:ListTags",
          "backup:PutBackupVaultAccessPolicy",
          "backup:PutBackupVaultNotifications",
          "backup:StartBackupJob",
          "backup:TagResource"
      ],
      "Resource": [
          "*"
      ]
    }
  ]
}
