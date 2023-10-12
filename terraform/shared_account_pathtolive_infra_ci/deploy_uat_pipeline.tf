resource "aws_codepipeline" "uat" {
  name     = "cjse-bichard7-path-to-live-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = module.codebuild_base_resources.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Update Tags"

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
    name = "Deploy UAT"

    action {
      category  = "Build"
      name      = "deploy-uat-environment"
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
  }
}
