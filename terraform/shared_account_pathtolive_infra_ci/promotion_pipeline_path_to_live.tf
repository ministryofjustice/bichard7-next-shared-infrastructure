resource "aws_codepipeline" "path_to_live" {
  name     = "cjse-bichard7-path-to-live-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = module.codebuild_base_resources.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "bichard-infra-source"

    action {
      name     = "application-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["application-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/application.json"
        PollForSourceChanges = true
      }
    }

    action {
      name     = "user-service-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["user-service-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/user-service.json"
        PollForSourceChanges = true
      }
    }

    action {
      name     = "audit-logging-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["audit-logging-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/audit-logging.json"
        PollForSourceChanges = true
      }
    }

    action {
      name     = "nginx-auth-proxy-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["nginx-auth-proxy-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/nginx-auth-proxy.json"
        PollForSourceChanges = true
      }
    }

    action {
      name             = "infrastructure-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["infrastructure"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-infrastructure"
        BranchName           = "master"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = true
      }
    }

    action {
      name             = "application-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["application"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next"
        BranchName           = "master"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = true
      }
    }

    action {
      name             = "tests-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tests"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-tests"
        BranchName           = "master"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }
  }

  stage {
    name = "update-e2e-test-environment"
    action {
      category        = "Build"
      name            = "fetch-and-update-e2e-test-deploy-tags"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      namespace       = "ImageHashes"
      run_order       = 1
      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.update_environment_ssm_params.pipeline_name
      }
    }

    action {
      category  = "Build"
      name      = "restart-e2e-test-pnc-emulator-before-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.run_e2e_tests_restart_pnc_container.pipeline_name
      }
    }
  }

  stage {
    name = "deploy-e2e-test-environment"
    action {
      category  = "Build"
      name      = "deploy-e2e-test-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.deploy_e2e_test_terraform.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "TF_VAR_override_deploy_tags"
              value = "true"
            },
            {
              name  = "TF_VAR_bichard_deploy_tag"
              value = "#{ImageHashes.WAS_APPLICATION_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_deploy_tag"
              value = "#{ImageHashes.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{ImageHashes.USER_SERVICE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{ImageHashes.NGINX_AUTH_PROXY_HASH}"
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }

    action {
      category  = "Build"
      name      = "run-e2e-test-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.run_e2e_test_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }
  }

  stage {
    name = "run-e2e-tests"

    action {
      category  = "Build"
      name      = "apply-dev-sgs-to-e2e-test"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1
      configuration = {
        ProjectName = module.apply_dev_sg_to_e2e_test.pipeline_name
      }

      input_artifacts = ["infrastructure"]
    }

    action {
      category  = "Build"
      name      = "run-e2e-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2
      configuration = {
        ProjectName = module.run_e2e_tests.pipeline_name
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "CODEPIPELINE_EXECUTION_ID"
              value = "#{codepipeline.PipelineExecutionId}"
            }
          ]
        )
      }

      input_artifacts = ["tests"]
    }

    action {
      category  = "Build"
      name      = "remove-dev-sgs-from-e2e-test"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3
      configuration = {
        ProjectName = module.remove_dev_sg_from_e2e_test.pipeline_name
      }

      input_artifacts = ["infrastructure"]
    }
  }

  stage {
    name = "fetch-and-update-preprod-environment"
    action {
      category = "Build"
      name     = "fetch-and-update-preprod-deploy-tags"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.update_environment_ssm_params.pipeline_name
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "preprod"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
            },
            {
              name  = "WAS_APPLICATION_HASH"
              value = "#{ImageHashes.WAS_APPLICATION_HASH}"
            },
            {
              name  = "AUDIT_LOGGING_HASH"
              value = "#{ImageHashes.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "USER_SERVICE_HASH"
              value = "#{ImageHashes.USER_SERVICE_HASH}"
            },
            {
              name  = "NGINX_AUTH_PROXY_HASH"
              value = "#{ImageHashes.NGINX_AUTH_PROXY_HASH}"
            }
          ]
        )
      }
    }
  }

  stage {
    name = "deploy-preprod-environment"
    action {
      category  = "Build"
      name      = "deploy-preprod-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.deploy_preprod_terraform.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "TF_VAR_override_deploy_tags"
              value = "true"
            },
            {
              name  = "TF_VAR_bichard_deploy_tag"
              value = "#{ImageHashes.WAS_APPLICATION_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_deploy_tag"
              value = "#{ImageHashes.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{ImageHashes.USER_SERVICE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{ImageHashes.NGINX_AUTH_PROXY_HASH}"
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }

    action {
      category  = "Build"
      name      = "run-preprod-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.run_preprod_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }
  }

  stage {
    name = "run-preprod-tests"

    action {
      category  = "Build"
      name      = "apply-dev-sgs-to-preprod"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1
      configuration = {
        ProjectName = module.apply_dev_sg_to_preprod.pipeline_name
      }

      input_artifacts = ["infrastructure"]
    }

    action {
      category  = "Build"
      name      = "run-preprod-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName = module.run_preprod_tests.pipeline_name
      }

      input_artifacts = ["tests"]
    }

    action {
      category  = "Build"
      name      = "remove-dev-sgs-from-preprod"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName = module.remove_dev_sg_from_preprod.pipeline_name
      }

      input_artifacts = ["infrastructure"]
    }
  }

  stage {
    name = "manual-approval-for-deploy-production"
    action {
      name     = "manual-approval-for-deploy-to-production"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = module.codebuild_base_resources.notifications_arn
        CustomData      = "Release to Load Test requires manual approval"
      }
    }
  }

  stage {
    name = "deploy-production-environment"
    action {
      category        = "Build"
      name            = "fetch-and-update-production-deploy-tags"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 1
      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.update_environment_ssm_params.pipeline_name
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "production"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
            },
            {
              name  = "WAS_APPLICATION_HASH"
              value = "#{ImageHashes.WAS_APPLICATION_HASH}"
            },
            {
              name  = "AUDIT_LOGGING_HASH"
              value = "#{ImageHashes.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "USER_SERVICE_HASH"
              value = "#{ImageHashes.USER_SERVICE_HASH}"
            },
            {
              name  = "NGINX_AUTH_PROXY_HASH"
              value = "#{ImageHashes.NGINX_AUTH_PROXY_HASH}"
            }
          ]
        )
      }
    }

    action {
      category  = "Build"
      name      = "deploy-production-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.deploy_production_terraform.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "TF_VAR_override_deploy_tags"
              value = "true"
            },
            {
              name  = "TF_VAR_bichard_deploy_tag"
              value = "#{ImageHashes.WAS_APPLICATION_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_deploy_tag"
              value = "#{ImageHashes.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{ImageHashes.USER_SERVICE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{ImageHashes.NGINX_AUTH_PROXY_HASH}"
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }

    action {
      category  = "Build"
      name      = "run-production-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName   = module.run_production_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }
  }

  stage {
    name = "run-production-smoketests"
    action {
      category = "Build"
      name     = "run-production-smoketests"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      configuration = {
        ProjectName   = module.run_prod_smoketests.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure"
      ]
    }
  }

  tags = module.label.tags
}

module "notify_pipeline" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codestar_notification"

  ci_cd_service_role_name = aws_iam_role.codepipeline_role.name
  name                    = aws_codepipeline.path_to_live.name
  notification_source_arn = aws_codepipeline.path_to_live.arn
  sns_kms_key_arn         = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn    = module.codebuild_base_resources.notifications_arn

  event_type_ids = [
    "codepipeline-pipeline-action-execution-failed",
    "codepipeline-pipeline-stage-execution-failed",
    "codepipeline-pipeline-pipeline-execution-failed"
  ]
  tags = module.label.tags
}

module "update_environment_ssm_params" {
  source                 = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"
  name                   = "update-environment-ssm-params"
  build_description      = "Updates our tagged ssm params for a deploy on e2e-test"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  repository_name        = "bichard7-next-infrastructure"
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  git_ref                = "master"
  buildspec_file         = "update-ssm-params.buildspec.yml"

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = "e2e-test"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
    },
    {
      name  = "WAS_REPO"
      value = module.codebuild_docker_resources.bichard_liberty_ecr.name
    },
    {
      name  = "AUDIT_REPO"
      value = module.codebuild_docker_resources.audit_logging_portal.name
    },
    {
      name  = "USER_REPO"
      value = module.codebuild_docker_resources.user_service_repository.name
    },
    {
      name  = "NGINX_AUTH_PROXY_REPO"
      value = module.codebuild_docker_resources.nginx_auth_proxy.name
    }
  ]

  tags = module.label.tags
}

module "run_prod_smoketests" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  build_description      = "Runs a basic smoketest against the prod environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-prod-smoketest"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  buildspec_file         = "prod-smoketest-buildspec.yml"
  event_type_ids         = []

  environment_variables = [
    {
      name  = "DEPLOY_ENV"
      value = "pathtolive"
    },
    {
      name  = "WORKSPACE"
      value = "production"
    },
    {
      name  = "ASSUME_ROLE_ARN"
      value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
    },
    {
      name  = "PARENT_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    },
    {
      name  = "AWS_ACCOUNT_NAME"
      value = "production"
    }
  ]
  tags = module.label.tags
}
