resource "aws_codepipeline" "development_promotion_pipeline" {
  name     = "cjse-bichard7-development-branch-pipeline"
  role_arn = aws_iam_role.develop_codepipeline_role.arn

  artifact_store {
    location = module.codebuild_base_resources.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "get-source-code"

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
        BranchName           = "develop"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
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
        BranchName           = "develop"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }

    action {
      name             = "user-service-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["userservice"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-user-service"
        BranchName           = "develop"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }

    action {
      name             = "audit-logging-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["auditlogging"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-audit-logging"
        BranchName           = "develop"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }

    action {
      name             = "docker-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["docker"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-infrastructure-docker-images"
        BranchName           = "develop"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }

    action {
      name             = "test-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tests"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-tests"
        BranchName           = "develop"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }
  }

  stage {
    name = "build-docker-containers"

    action {
      category  = "Build"
      name      = "build-application"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      namespace = "Application"

      input_artifacts = ["application"]

      configuration = {
        ProjectName = module.common_build_jobs.build_bichard7_application_name
      }
    }

    action {
      category  = "Build"
      name      = "build-user-service"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      namespace = "UserService"

      input_artifacts = ["userservice"]

      configuration = {
        ProjectName = module.common_build_jobs.build_bichard7_application_name
      }
    }

    action {
      category  = "Build"
      name      = "build-nginx-auth-proxy"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      namespace = "AuthProxy"

      input_artifacts = ["docker"]

      configuration = {
        ProjectName = module.common_build_jobs.build_auth_proxy_name
      }
    }

    action {
      category  = "Build"
      name      = "build-audit-logging"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      namespace = "AuditLogging"

      input_artifacts = ["auditlogging"]

      configuration = {
        ProjectName = module.common_build_jobs.build_audit_logging_name
      }
    }
  }

  stage {
    name = "deploy-and-run-integration-tests"

    action {
      category  = "Build"
      name      = "deploy-int-test-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.deploy_integration_test_terraform.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "TF_VAR_override_deploy_tags"
              value = "true"
            },
            {
              name  = "TF_VAR_bichard_deploy_tag"
              value = "#{Application.WAS_APPLICATION_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_deploy_tag"
              value = "#{AuditLogging.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{UserService.USER_SERVICE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{AuthProxy.NGINX_AUTH_PROXY_HASH}"
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
      name      = "run-int-test-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.run_integration_test_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }

    action {
      category  = "Build"
      name      = "restart-int-test-pnc-emulator-before-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      input_artifacts = ["infrastructure"]

      configuration = {
        ProjectName = module.run_integration_tests_restart_pnc_container.pipeline_name
      }
    }

    action {
      category  = "Build"
      name      = "run-integration-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName = module.run_integration_tests.pipeline_name
      }

      input_artifacts = ["tests"]
    }
  }

  stage {
    name = "deploy-and-run-load-tests"

    action {
      category  = "Build"
      name      = "deploy-load-test-environment"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      configuration = {
        ProjectName   = module.deploy_load_test_terraform.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "TF_VAR_override_deploy_tags"
              value = "true"
            },
            {
              name  = "TF_VAR_bichard_deploy_tag"
              value = "#{Application.WAS_APPLICATION_HASH}"
            },
            {
              name  = "TF_VAR_audit_logging_deploy_tag"
              value = "#{AuditLogging.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "TF_VAR_user_service_deploy_tag"
              value = "#{UserService.USER_SERVICE_HASH}"
            },
            {
              name  = "TF_VAR_nginx_auth_proxy_deploy_tag"
              value = "#{AuthProxy.NGINX_AUTH_PROXY_HASH}"
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
      name      = "run-load-test-migrations"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 2

      configuration = {
        ProjectName   = module.run_load_test_migrations.pipeline_name
        PrimarySource = "infrastructure"
      }

      input_artifacts = [
        "infrastructure",
        "application"
      ]
    }

    action {
      category  = "Build"
      name      = "run-load-tests"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      configuration = {
        ProjectName = module.run_load_tests.pipeline_name
      }

      input_artifacts = ["tests"]
    }
  }

  stage {
    name = "tag-passing-build"

    action {
      category  = "Build"
      name      = "tag-passing-build-with-develop-tag"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1
      namespace = "RepositoryTags"

      configuration = {
        ProjectName   = module.tag_develop_release.pipeline_name
        PrimarySource = "infrastructure"
        EnvironmentVariables = jsonencode(
          [
            {
              name  = "BICHARD7_NEXT_IMAGE_HASH"
              value = "bichard7-liberty: #{Application.WAS_APPLICATION_HASH}"
            },
            {
              name  = "BICHARD7_NEXT_AUDIT_LOGGING_IMAGE_HASH"
              value = "audit-logging: #{AuditLogging.AUDIT_LOGGING_HASH}"
            },
            {
              name  = "BICHARD7_NEXT_USER_SERVICE_IMAGE_HASH"
              value = "user-service: #{UserService.USER_SERVICE_HASH}"
            },
            {
              name  = "BICHARD7_NEXT_INFRASTRUCTURE_DOCKER_IMAGES_IMAGE_HASH"
              value = "nginx-auth-proxy: #{AuthProxy.NGINX_AUTH_PROXY_HASH}"
            }
          ]
        )
      }

      input_artifacts = [
        "infrastructure",
        "application",
        "userservice",
        "auditlogging",
        "docker"
      ]
    }
  }
  tags = module.label.tags
}

module "notify_development_promotion_pipeline" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codestar_notification"

  ci_cd_service_role_name = aws_iam_role.develop_codepipeline_role.name
  name                    = aws_codepipeline.development_promotion_pipeline.name
  notification_source_arn = aws_codepipeline.development_promotion_pipeline.arn
  sns_kms_key_arn         = module.codebuild_base_resources.notifications_kms_key_arn
  sns_notification_arn    = module.codebuild_base_resources.notifications_arn

  event_type_ids = [
    "codepipeline-pipeline-action-execution-failed",
    "codepipeline-pipeline-stage-execution-failed",
    "codepipeline-pipeline-pipeline-execution-failed"
  ]
  tags = module.label.tags
}
