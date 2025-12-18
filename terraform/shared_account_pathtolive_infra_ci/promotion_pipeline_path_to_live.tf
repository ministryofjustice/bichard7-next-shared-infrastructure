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
      name     = "ui-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["ui-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/ui.json"
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
      name     = "conductor-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["conductor-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/conductor.json"
        PollForSourceChanges = true
      }
    }

    action {
      name     = "core-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["core-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/core-worker.json"
        PollForSourceChanges = true
      }
    }

    action {
      name     = "api-semaphore"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["api-semaphore"]

      configuration = {
        S3Bucket             = module.codebuild_base_resources.codepipeline_bucket
        S3ObjectKey          = "semaphores/api.json"
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
        BranchName           = "main"
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
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = true
      }
    }

    action {
      name             = "core-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["core"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-core"
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = true
      }
    }
  }

  stage {
    name = "deploy-and-test-e2e-test-environment"
    action {
      category        = "Build"
      name            = "fetch-and-update-e2e-test-deploy-tags"
      owner           = "AWS"
      provider        = "CodeBuild"
      run_order       = 1
      version         = "1"
      namespace       = "HASHES"
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
      run_order = 1
      version   = "1"

      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.run_e2e_tests_restart_pnc_container.pipeline_name
      }
    }

    action {
      category  = "Build"
      name      = "deploy-e2e-test-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

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
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_fn_hash"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_core_fn_hash"
              value = "#{HASHES.CORE_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_ui_deploy_tag"
              value = "#{HASHES.UI_IMAGE_HASH}"
            },
            {
              name  = "INFRA_MODULES_COMMIT_HASH"
              value = "#{HASHES.INFRA_MODULES_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_conductor_deploy_tag"
              value = "#{HASHES.CONDUCTOR_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_core_worker_deploy_tag"
              value = "#{HASHES.CORE_WORKER_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_api_deploy_tag"
              value = "#{HASHES.API_IMAGE_HASH}"
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
      run_order = 2

      configuration = {
        ProjectName   = module.run_e2e_test_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-conductor-definitions"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.deploy_e2e_test_conductor_definitions.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "verify-e2e-test-ecs-services"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName   = module.verify_ecs_tasks.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "e2e-test"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-e2e-test-help-docs"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 4

      configuration = {
        ProjectName   = module.deploy_help_docs.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "e2e-test"
            },
            {
              name  = "WORKSPACE"
              value = "e2e-test"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_next_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "run-e2e-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 5
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

      input_artifacts = ["core"]
    }
  }

  stage {
    name = "deploy-and-test-leds-test-environment"
    action {
      category        = "Build"
      name            = "fetch-and-update-leds-test-deploy-tags"
      owner           = "AWS"
      provider        = "CodeBuild"
      run_order       = 1
      version         = "1"
      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.update_environment_ssm_params.pipeline_name
      }
    }

    # action {
    #   category  = "Build"
    #   name      = "deploy-leds-test-environment"
    #   owner     = "AWS"
    #   provider  = "CodeBuild"
    #   version   = "1"
    #   run_order = 2

    configuration = {
      ProjectName   = module.deploy_leds_test_environment_terraform.pipeline_name
      PrimarySource = "infrastructure"
      EnvironmentVariables = jsonencode(
        [
          {
            name  = "TF_VAR_override_deploy_tags"
            value = "true"
          },
          {
            name  = "TF_VAR_bichard_deploy_tag"
            value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
          },
          {
            name  = "TF_VAR_audit_logging_fn_hash"
            value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
          },
          {
            name  = "TF_VAR_core_fn_hash"
            value = "#{HASHES.CORE_COMMIT_HASH}"
          },
          {
            name  = "TF_VAR_user_service_deploy_tag"
            value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
          },
          {
            name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
            value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
          },
          {
            name  = "TF_VAR_ui_deploy_tag"
            value = "#{HASHES.UI_IMAGE_HASH}"
          },
          {
            name  = "INFRA_MODULES_COMMIT_HASH"
            value = "#{HASHES.INFRA_MODULES_COMMIT_HASH}"
          },
          {
            name  = "TF_VAR_conductor_deploy_tag"
            value = "#{HASHES.CONDUCTOR_IMAGE_HASH}"
          },
          {
            name  = "TF_VAR_core_worker_deploy_tag"
            value = "#{HASHES.CORE_WORKER_IMAGE_HASH}"
          },
          {
            name  = "TF_VAR_api_deploy_tag"
            value = "#{HASHES.API_IMAGE_HASH}"
          },
          {
            name  = "TF_VAR_deploy_private_hosted_zone_association"
            value = "true"
          },
          {
            name  = "TF_VAR_deploy_tgw_attachment"
            value = "false"
          },
          {
            name  = "TF_VAR_deploy_leds_api_tgw_routes"
            value = "false"
          }
        ]
      )
    }

    #   input_artifacts = [
    #     "infrastructure",
    #     "application"
    #   ]
    # }

    action {
      category  = "Build"
      name      = "run-leds-test-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.run_leds_test_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-leds-conductor-definitions"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.deploy_leds_conductor_definitions.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "verify-leds-test-ecs-services"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName   = module.verify_ecs_tasks.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "leds"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-leds-help-docs"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 4

      configuration = {
        ProjectName   = module.deploy_help_docs.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "leds"
            },
            {
              name  = "WORKSPACE"
              value = "leds"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }
  }

  stage {
    name = "deploy-and-test-preprod-environment"
    action {
      category  = "Build"
      name      = "fetch-and-update-preprod-deploy-tags"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

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
              name  = "WAS_APPLICATION_IMAGE_HASH"
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "USER_SERVICE_IMAGE_HASH"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "NGINX_AUTH_PROXY_IMAGE_HASH"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "UI_IMAGE_HASH"
              value = "#{HASHES.UI_IMAGE_HASH}"
            }
          ]
        )
      }
    }

    action {
      category  = "Build"
      name      = "deploy-preprod-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

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
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_fn_hash"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_core_fn_hash"
              value = "#{HASHES.CORE_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_ui_deploy_tag"
              value = "#{HASHES.UI_IMAGE_HASH}"
            },
            {
              name  = "INFRA_MODULES_COMMIT_HASH"
              value = "#{HASHES.INFRA_MODULES_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_conductor_deploy_tag"
              value = "#{HASHES.CONDUCTOR_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_core_worker_deploy_tag"
              value = "#{HASHES.CORE_WORKER_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_api_deploy_tag"
              value = "#{HASHES.API_IMAGE_HASH}"
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
      run_order = 2

      configuration = {
        ProjectName   = module.run_preprod_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-conductor-definitions"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.deploy_preprod_conductor_definitions.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "verify-preprod-ecs-services"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName   = module.verify_ecs_tasks.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "preprod"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-preprod-help-docs"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 4

      configuration = {
        ProjectName   = module.deploy_help_docs.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "preprod"
            },
            {
              name  = "WORKSPACE"
              value = "preprod"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.preprod_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "run-preprod-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 5

      configuration = {
        ProjectName = module.run_preprod_tests.pipeline_name
      }

      input_artifacts = ["core"]
    }
  }

  stage {
    name = "manual-approval-for-deploy-production"

    action {
      category = "Build"
      name     = "generate-code-to-be-deployed-diff"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      configuration = {
        ProjectName   = module.code_to_be_deployed.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "WAS_APPLICATION_COMMIT_HASH"
              value = "#{HASHES.WAS_APPLICATION_COMMIT_HASH}"
            },
            {
              name  = "AUDIT_LOGGING_COMMIT_HASH"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "CORE_COMMIT_HASH"
              value = "#{HASHES.CORE_COMMIT_HASH}"
            },
            {
              name  = "USER_SERVICE_COMMIT_HASH"
              value = "#{HASHES.USER_SERVICE_COMMIT_HASH}"
            },
            {
              name  = "NGINX_AUTH_PROXY_COMMIT_HASH"
              value = "#{HASHES.NGINX_AUTH_PROXY_COMMIT_HASH}"
            },
            {
              name  = "UI_COMMIT_HASH"
              value = "#{HASHES.UI_COMMIT_HASH}"
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure"
      ]
    }

    action {
      name     = "manual-approval-for-deploy-to-production"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = module.codebuild_base_resources.notifications_arn
        CustomData      = "Release to Production requires manual approval"
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
              name  = "WAS_APPLICATION_IMAGE_HASH"
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "AUDIT_LOGGING_COMMIT_HASH"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "USER_SERVICE_IMAGE_HASH"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "NGINX_AUTH_PROXY_IMAGE_HASH"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "UI_IMAGE_HASH"
              value = "#{HASHES.UI_IMAGE_HASH}"
            }
          ]
        )
      }
    }

    action {
      category        = "Build"
      name            = "fetch-and-update-uat-deploy-tags"
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
              value = "uat"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
            },
            {
              name  = "WAS_APPLICATION_IMAGE_HASH"
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "AUDIT_LOGGING_COMMIT_HASH"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "USER_SERVICE_IMAGE_HASH"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "NGINX_AUTH_PROXY_IMAGE_HASH"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "UI_IMAGE_HASH"
              value = "#{HASHES.UI_IMAGE_HASH}"
            }
          ]
        )
      }
    }

    action {
      category        = "Build"
      name            = "post-deploying-to-prod-notification"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 1
      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.notify_deploying_to_prod.pipeline_name
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
              name  = "CODEPIPELINE_PIPELINE_EXECUTION_ID"
              value = "#{codepipeline.PipelineExecutionId}"
            }
          ]
        )
      }
    }

    action {
      category  = "Build"
      name      = "deploy-uat-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.deploy_uat_terraform.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "TF_VAR_override_deploy_tags"
              value = "true"
            },
            {
              name  = "TF_VAR_bichard_deploy_tag"
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_fn_hash"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_core_fn_hash"
              value = "#{HASHES.CORE_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_ui_deploy_tag"
              value = "#{HASHES.UI_IMAGE_HASH}"
            },
            {
              name  = "INFRA_MODULES_COMMIT_HASH"
              value = "#{HASHES.INFRA_MODULES_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_conductor_deploy_tag"
              value = "#{HASHES.CONDUCTOR_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_core_worker_deploy_tag"
              value = "#{HASHES.CORE_WORKER_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_api_deploy_tag"
              value = "#{HASHES.API_IMAGE_HASH}"
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
      name      = "deploy-production-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

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
              value = "#{HASHES.WAS_APPLICATION_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_fn_hash"
              value = "#{HASHES.AUDIT_LOGGING_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_core_fn_hash"
              value = "#{HASHES.CORE_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{HASHES.USER_SERVICE_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{HASHES.NGINX_AUTH_PROXY_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_ui_deploy_tag"
              value = "#{HASHES.UI_IMAGE_HASH}"
            },
            {
              name  = "INFRA_MODULES_COMMIT_HASH"
              value = "#{HASHES.INFRA_MODULES_COMMIT_HASH}"
            },
            {
              name  = "TF_VAR_conductor_deploy_tag"
              value = "#{HASHES.CONDUCTOR_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_core_worker_deploy_tag"
              value = "#{HASHES.CORE_WORKER_IMAGE_HASH}"
            },
            {
              name  = "TF_VAR_api_deploy_tag"
              value = "#{HASHES.API_IMAGE_HASH}"
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
      run_order = 2

      configuration = {
        ProjectName   = module.run_production_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application",
        "core"
      ]
    }

    action {
      category = "Build"
      name     = "deploy-conductor-definitions"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      configuration = {
        ProjectName   = module.deploy_production_conductor_definitions.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "run-uat-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.run_uat_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application",
        "core"
      ]
    }

    action {
      category = "Build"
      name     = "deploy-uat-conductor-definitions"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      configuration = {
        ProjectName   = module.deploy_uat_conductor_definitions.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }
  }

  stage {
    name = "run-production-smoketests"

    action {
      category  = "Build"
      name      = "verify-production-ecs-services"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.verify_ecs_tasks.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "production"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure"
      ]
    }

    action {
      category  = "Build"
      name      = "verify-uat-ecs-services"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.verify_ecs_tasks.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "uat"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-uat-help-docs"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.deploy_help_docs.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "uat"
            },
            {
              name  = "WORKSPACE"
              value = "uat"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.integration_baseline_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "deploy-production-help-docs"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.deploy_help_docs.pipeline_name
        PrimarySource = "infrastructure"

        EnvironmentVariables = jsonencode(
          [
            {
              name  = "ENVIRONMENT"
              value = "production"
            },
            {
              name  = "WORKSPACE"
              value = "production"
            },
            {
              name  = "ASSUME_ROLE_ARN"
              value = data.terraform_remote_state.shared_infra.outputs.production_ci_arn
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "core"
      ]
    }

    action {
      category  = "Build"
      name      = "run-production-smoketests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName   = module.run_prod_smoketests.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure"
      ]
    }
  }
}
module "notify_pipeline" {
  source = "../modules/codestar_notification"

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
  source                 = "../modules/codebuild_job"
  name                   = "update-environment-ssm-params"
  build_description      = "Updates our tagged ssm params for a deploy on e2e-test"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  repository_name        = "bichard7-next-infrastructure"
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  git_ref                = "main"
  buildspec_file         = "buildspecs/update-ssm-params.buildspec.yml"

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
    },
    {
      name  = "UI_REPO"
      value = module.codebuild_docker_resources.ui_repository.name
    },
  ]

  tags = module.label.tags
}

module "code_to_be_deployed" {
  source = "../modules/codebuild_job"

  build_description      = "Output a diff of the code to be deployed"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "generate-code-to-be-deployed-diff"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  buildspec_file         = "buildspecs/code-to-be-deployed.yml"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_SMALL"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = true
      image                       = "${data.aws_ecr_repository.codebuild_2023_base.repository_url}@${data.external.latest_codebuild_2023_base.result.tags}"
      image_pull_credentials_type = "SERVICE_ROLE"
    }
  ]

  tags = module.label.tags
}

module "notify_deploying_to_prod" {
  source = "../modules/codebuild_job"

  build_description      = "Post a 'Deploying to prod' notification to the alerts channel"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "deploying-to-prod-notification"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  buildspec_file         = "buildspecs/deploying-to-prod-notification.yml"

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn
  ]

  build_environments = [
    {
      compute_type                = "BUILD_GENERAL1_SMALL"
      type                        = "LINUX_CONTAINER"
      privileged_mode             = false
      image                       = local.amazon_linux_2023
      image_pull_credentials_type = "CODEBUILD"
    }
  ]

  tags = module.label.tags
}

module "run_prod_smoketests" {
  source = "../modules/codebuild_job"

  build_description      = "Runs a basic smoketest against the prod environment"
  codepipeline_s3_bucket = module.codebuild_base_resources.codepipeline_bucket
  name                   = "run-prod-smoketest"
  repository_name        = "bichard7-next-infrastructure"
  sns_kms_key_arn        = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn   = module.codebuild_base_resources.notifications_arn
  buildspec_file         = "buildspecs/prod-smoketest-buildspec.yml"
  event_type_ids         = []
  vpc_config             = module.codebuild_base_resources.codebuild_vpc_config_blocks["production"]

  allowed_resource_arns = [
    data.aws_ecr_repository.codebuild_base.arn,
    module.codebuild_docker_resources.codebuild_2023_base.arn
  ]

  build_environments = local.codebuild_2023_pipeline_build_environments

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
