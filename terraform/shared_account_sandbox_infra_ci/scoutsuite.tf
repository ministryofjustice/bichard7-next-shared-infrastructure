module "scoutsuite_scan_shared" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "scoutsuite-scan-sandbox-shared"
  build_description = "Scoutsuite scan on account bichard7-sandbox-shared"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "scoutsuite-buildspec.yml"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_block

  event_type_ids = []

  build_environments = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = module.codebuild_docker_resources.scoutsuite_docker_image
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]

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

  depends_on = [
    module.codebuild_base_resources
  ]
}

module "scoutsuite_scan_shared_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_shared.pipeline_arn
  name            = module.scoutsuite_scan_shared.pipeline_name
  cron_expression = "cron(0 13 ? * MON-FRI *)"

  tags = module.label.tags
}

module "scoutsuite_scan_sandbox_a" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "scoutsuite-scan-sandbox-a"
  build_description = "Scoutsuite scan on account bichard7-sandbox-a"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "scoutsuite-buildspec.yml"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_block

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
      value = data.aws_caller_identity.sandbox_a.account_id
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
      value = "sandbox_a"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_base_resources
  ]
}

module "scoutsuite_scan_sandbox_a_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_sandbox_a.pipeline_arn
  name            = module.scoutsuite_scan_sandbox_a.pipeline_name
  cron_expression = "cron(15 13 ? * MON-FRI *)"

  tags = module.label.tags
}

module "scoutsuite_scan_sandbox_b" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "scoutsuite-scan-sandbox-b"
  build_description = "Scoutsuite scan on account bichard7-sandbox-b"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "scoutsuite-buildspec.yml"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_block

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
      value = data.aws_caller_identity.sandbox_b.account_id
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
      value = "sandbox_b"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_base_resources
  ]
}

module "scoutsuite_scan_sandbox_b_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_sandbox_b.pipeline_arn
  name            = module.scoutsuite_scan_sandbox_b.pipeline_name
  cron_expression = "cron(30 13 ? * MON-FRI *)"

  tags = module.label.tags
}

module "scoutsuite_scan_sandbox_c" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "scoutsuite-scan-sandbox-c"
  build_description = "Scoutsuite scan on account bichard7-sandbox-c"
  repository_name   = "bichard7-next-infrastructure"
  buildspec_file    = "scoutsuite-buildspec.yml"
  vpc_config        = module.codebuild_base_resources.codebuild_vpc_config_block

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
      value = data.aws_caller_identity.sandbox_c.account_id
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
      value = "sandbox_c"
    }
  ]

  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  sns_notification_arn   = module.codebuild_base_resources.scanning_notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.scanning_notifications_kms_key_arn

  tags = module.label.tags

  depends_on = [
    module.codebuild_base_resources
  ]
}

module "scoutsuite_scan_sandbox_c_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.scoutsuite_scan_sandbox_c.pipeline_arn
  name            = module.scoutsuite_scan_sandbox_c.pipeline_name
  cron_expression = "cron(45 13 ? * MON-FRI *)"

  tags = module.label.tags
}
