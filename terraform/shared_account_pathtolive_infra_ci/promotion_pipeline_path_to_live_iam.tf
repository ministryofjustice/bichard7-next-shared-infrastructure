resource "aws_iam_role" "codepipeline_role" {
  name = "cjse-bichard7-path-to-live-deploy-role"

  assume_role_policy = file("${path.module}/policies/codepipeline_policy.json")

  tags = module.label.tags
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "cjse-bichard7-path-to-live-deploy-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = templatefile(
    "${path.module}/policies/codepipeline_role_policy.json",
    {
      account_id    = data.aws_caller_identity.current.account_id
      region        = data.aws_region.current_region.name
      bucket_arn    = module.codebuild_base_resources.codepipeline_bucket_arn
      sns_topic_arn = module.codebuild_base_resources.notifications_arn
    }
  )
}




#### Addenda to service roles
resource "aws_iam_role_policy" "update_e2e_test_ssm_params" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.update_environment_ssm_params.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_e2e_tests" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_e2e_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_preprod_tests" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_preprod_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_e2e_test" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_e2e_test_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_conductor_definitions_e2e_test" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_e2e_test_conductor_definitions.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_conductor_definitions_preprod" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_preprod_conductor_definitions.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_conductor_definitions_production" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_production_conductor_definitions.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_pre_prod" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_preprod_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_load_test" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_load_test_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_production" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_production_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_production_smoketests" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_prod_smoketests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_load_tests" {
  name   = "Allow-Codestar-Connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_load_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "restart_pnc_emulator_e2e_tests" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_e2e_tests_restart_pnc_container.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_e2e_test_migrations" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_e2e_test_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_preprod_migrations" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_preprod_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_load_test_migrations" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_load_test_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_production_migrations" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_production_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "apply_dev_sg_to_preprod" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.apply_dev_sg_to_preprod.pipeline_service_role_name
}

resource "aws_iam_role_policy" "remove_dev_sg_from_preprod" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.remove_dev_sg_from_preprod.pipeline_service_role_name
}

resource "aws_iam_role_policy" "apply_dev_sg_to_e2e_test" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.apply_dev_sg_to_e2e_test.pipeline_service_role_name
}

resource "aws_iam_role_policy" "remove_dev_sg_from_e2e_test" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.remove_dev_sg_from_e2e_test.pipeline_service_role_name
}

resource "aws_iam_role_policy" "code_to_be_deployed" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.code_to_be_deployed.pipeline_service_role_name
}

resource "aws_iam_role_policy" "notify_deploying_to_prod" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.notify_deploying_to_prod.pipeline_service_role_name
}

resource "aws_iam_role_policy" "verify_ecs_tasks" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.verify_ecs_tasks.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_uat_terraform" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_uat_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_uat_migrations" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_uat_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_uat_conductor_definitions" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_uat_conductor_definitions.pipeline_service_role_name
}

resource "aws_iam_role_policy" "apply_dev_sg_to_uat" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.apply_dev_sg_to_uat.pipeline_service_role_name
}

resource "aws_iam_role_policy" "remove_dev_sg_from_uat" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.remove_dev_sg_from_uat.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_leds_terraform" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_leds_test_environment_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_leds_test_migrations" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.run_leds_test_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_leds_conductor_definitions" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.deploy_leds_conductor_definitions.pipeline_service_role_name
}

resource "aws_iam_role_policy" "apply_dev_sg_to_leds" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.apply_dev_sg_to_uat.pipeline_service_role_name
}

resource "aws_iam_role_policy" "remove_dev_sg_from_leds" {
  name   = "allow-codestar-connection"
  policy = local.allow_codebuild_codestar_connection_policy
  role   = module.remove_dev_sg_from_uat.pipeline_service_role_name
}
