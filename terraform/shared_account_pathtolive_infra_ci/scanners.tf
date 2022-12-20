module "scoutsuite_scan_shared" {
  source = "../modules/codebuild_job"

  name              = "scoutsuite-scan-shared"
  build_description = "Scoutsuite scan on account bichard7-shared"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/scoutsuite-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = module.codebuild_docker_resources.scoutsuite_docker_image
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  event_type_ids = []

  environment_variables = [
    {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "CHILD_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "UPLOAD_BUCKET"
      value = module.codebuild_base_resources.scanning_results_bucket
    },
    {
      name  = "PARENT_ACCOUNT"
      value = true
    },
    {
      name  = "ACCOUNT_ALIAS"
      value = "sandbox_shared"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags
}

module "scoutsuite_scan_shared_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_shared.pipeline_arn
  name            = module.scoutsuite_scan_shared.pipeline_name
  cron_expression = "cron(0 14 ? * MON-FRI *)"

  tags = module.label.tags
}

module "scoutsuite_scan_integration_next" {
  source = "../modules/codebuild_job"

  name              = "scoutsuite-scan-integration-next"
  build_description = "Scoutsuite scan on account bichard7-integration-next"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/scoutsuite-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = module.codebuild_docker_resources.scoutsuite_docker_image
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  event_type_ids = []

  environment_variables = [
    {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "CHILD_ACCOUNT_ID"
      value = data.aws_caller_identity.integration_next.account_id
    },
    {
      name  = "UPLOAD_BUCKET"
      value = module.codebuild_base_resources.scanning_results_bucket
    },
    {
      name  = "PARENT_ACCOUNT"
      value = false
    },
    {
      name  = "ACCOUNT_ALIAS"
      value = "integration_next"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags
}

module "scoutsuite_scan_integration_next_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_integration_next.pipeline_arn
  name            = module.scoutsuite_scan_integration_next.pipeline_name
  cron_expression = "cron(15 14 ? * MON-FRI *)"

  tags = module.label.tags
}

module "scoutsuite_scan_integration_baseline" {
  source = "../modules/codebuild_job"

  name              = "scoutsuite-scan-integration-baseline"
  build_description = "Scoutsuite scan on account bichard7-integration-baseline"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/scoutsuite-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = module.codebuild_docker_resources.scoutsuite_docker_image
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  event_type_ids = []

  environment_variables = [
    {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "CHILD_ACCOUNT_ID"
      value = data.aws_caller_identity.integration_baseline.account_id
    },
    {
      name  = "UPLOAD_BUCKET"
      value = module.codebuild_base_resources.scanning_results_bucket
    },
    {
      name  = "PARENT_ACCOUNT"
      value = false
    },
    {
      name  = "ACCOUNT_ALIAS"
      value = "integration_baseline"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags
}

module "scoutsuite_scan_integration_baseline_schedule" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_integration_baseline.pipeline_arn
  name            = module.scoutsuite_scan_integration_baseline.pipeline_name
  cron_expression = "cron(30 14 ? * MON-FRI *)"

  tags = module.label.tags
}

module "owasp_scan_e2e_test" {
  source            = "../modules/codebuild_job"
  name              = "owasp-scan-e2e-test"
  build_description = "Codebuild Pipeline for running OWASP scans on our infrastructure"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/zap-owasp-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  event_type_ids = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.zap_owasp_scanner_repository_arn
  ]

  environment_variables = [
    {
      name  = "OWASP_DOCKER_IMAGE"
      value = module.codebuild_docker_resources.zap_owasp_scanner_docker_image
    },
    {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "CHILD_ACCOUNT_ID"
      value = data.aws_caller_identity.integration_next.account_id
    },
    {
      name  = "UPLOAD_BUCKET"
      value = module.codebuild_base_resources.scanning_results_bucket
    },
    {
      name  = "ACCOUNT_ALIAS"
      value = "test-next"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
    },
    {
      name  = "ENVIRONMENT"
      value = "ptl"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "owasp_scan_e2e_test_user_service" {
  source            = "../modules/codebuild_job"
  name              = "owasp-scan-e2e-test-user-service"
  build_description = "Codebuild Pipeline for running OWASP scans on our infrastructure"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/zap-owasp-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  event_type_ids = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.zap_owasp_scanner_repository_arn
  ]

  environment_variables = [
    {
      name  = "OWASP_DOCKER_IMAGE"
      value = module.codebuild_docker_resources.zap_owasp_scanner_docker_image
    },
    {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "CHILD_ACCOUNT_ID"
      value = data.aws_caller_identity.integration_next.account_id
    },
    {
      name  = "UPLOAD_BUCKET"
      value = module.codebuild_base_resources.scanning_results_bucket
    },
    {
      name  = "ACCOUNT_ALIAS"
      value = "test-next"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
    },
    {
      name  = "ENVIRONMENT"
      value = "ptl"
    },
    {
      name  = "ZAP_SCRIPT"
      value = "user_service"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "owasp_scan_e2e_test_audit_logging" {
  source            = "../modules/codebuild_job"
  name              = "owasp-audit-logging-scan-e2e-test"
  build_description = "Codebuild Pipeline for running OWASP scans on our infrastructure"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "buildspecs/zap-owasp-buildspec.yml"

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

  event_type_ids = []

  allowed_resource_arns = [
    module.codebuild_docker_resources.zap_owasp_scanner_repository_arn
  ]

  environment_variables = [
    {
      name  = "OWASP_DOCKER_IMAGE"
      value = module.codebuild_docker_resources.zap_owasp_scanner_docker_image
    },
    {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "CHILD_ACCOUNT_ID"
      value = data.aws_caller_identity.integration_next.account_id
    },
    {
      name  = "UPLOAD_BUCKET"
      value = module.codebuild_base_resources.scanning_results_bucket
    },
    {
      name  = "ACCOUNT_ALIAS"
      value = "test-next"
    },
    {
      name  = "WORKSPACE"
      value = "e2e-test"
    },
    {
      name  = "ENVIRONMENT"
      value = "ptl"
    },
    {
      name  = "PREFIX"
      value = "audit"
    },
    {
      name  = "SKIP_AUTH"
      value = "true"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_docker_resources
  ]
}

module "owasp_scan_e2e_test_trigger" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.owasp_scan_e2e_test.pipeline_arn
  cron_expression = "cron(15 13 ? * MON-FRI *)"
  name            = module.owasp_scan_e2e_test.pipeline_name

  tags = module.label.tags
}

module "owasp_scan_e2e_test_audit_logging_trigger" {
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.owasp_scan_e2e_test_audit_logging.pipeline_arn
  cron_expression = "cron(15 13 ? * MON-FRI *)"
  name            = module.owasp_scan_e2e_test_audit_logging.pipeline_name

  tags = module.label.tags
}

module "owasp_scan_e2e_test_user_service_trigger" {
  count           = 0
  source          = "../modules/codebuild_schedule"
  codebuild_arn   = module.owasp_scan_e2e_test_user_service.pipeline_arn
  cron_expression = "cron(15 13 ? * MON-FRI *)"
  name            = module.owasp_scan_e2e_test_user_service.pipeline_name

  tags = module.label.tags
}
