resource "aws_codepipeline" "uat" {
  name     = "cjse-bichard7-uat-deploy-pipeline"
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
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }

    action {
      name             = "ui-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["ui"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "ministryofjustice/bichard7-next-ui"
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }
  }

  stage {
    name = "manual-approval-for-deploy-uat"
    action {
      name     = "manual-approval-for-deploy-to-uat"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = module.codebuild_base_resources.notifications_arn
        CustomData      = "Release to UAT requires manual approval"
      }
    }
  }
  stage {
    name = "update_tags"

    action {
      category        = "Build"
      name            = "fetch-and-update-uat-deploy-tags"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
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
  }

  stage {
    name = "deploy_uat"

    action {
      category = "Build"
      name     = "deploy-uat-environment"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

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
  }

  stage {
    name = "run_uat_migrations"

    action {
      category = "Build"
      name     = "run-uat-migrations"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

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
      name     = "deploy-conductor-definitions"
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
}
