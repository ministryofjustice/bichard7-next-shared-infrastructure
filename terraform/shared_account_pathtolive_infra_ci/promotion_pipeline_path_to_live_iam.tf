resource "aws_iam_role" "codepipeline_role" {
  name = "cjse-bichard7-path-to-live-deploy-role"

  assume_role_policy = file("${path.module}/policies/codepipeline_policy.json")
}

data "template_file" "codepipeline_policy_template" {
  template = file("${path.module}/policies/codepipeline_role_policy.json")

  vars = {
    account_id    = data.aws_caller_identity.current.account_id
    region        = data.aws_region.current_region.name
    bucket_arn    = module.codebuild_base_resources.codepipeline_bucket_arn
    sns_topic_arn = module.codebuild_base_resources.notifications_arn
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "cjse-bichard7-path-to-live-deploy-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = data.template_file.codepipeline_policy_template.rendered
}

data "template_file" "kms_permissions" {
  template = file("${path.module}/policies/codebuild_kms_permissions.json")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}


#### Addenda to service roles


data "template_file" "allow_codebuild_codestar_connection" {
  template = file("${path.module}/policies/allow_codebuild_codestar_connection.json")

  vars = {
    codestar_arn = aws_codestarconnections_connection.github.id
  }
}

resource "aws_iam_role_policy" "update_e2e_test_ssm_params" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.update_environment_ssm_params.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_e2e_tests" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_e2e_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_preprod_tests" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_preprod_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_e2e_test" {
  name   = "Allow-Codestar-Connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_e2e_test_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_pre_prod" {
  name   = "Allow-Codestar-Connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_preprod_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_load_test" {
  name   = "Allow-Codestar-Connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_load_test_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_deploy_production" {
  name   = "Allow-Codestar-Connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_production_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_production_smoketests" {
  name   = "Allow-Codestar-Connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_prod_smoketests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "allow_code_pipeline_connection_for_load_tests" {
  name   = "Allow-Codestar-Connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_load_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "restart_pnc_emulator_e2e_tests" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_e2e_tests_restart_pnc_container.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_e2e_test_smtp_service" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_e2e_test_smtp_service.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_e2e_test_monitoring_layer" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_e2e_test_monitoring_layer.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_e2e_test_migrations" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_e2e_test_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_preprod_migrations" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_preprod_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_load_test_monitoring_layer" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_load_test_monitoring_layer.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_load_test_migrations" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_load_test_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_production_smtp_service" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_production_smtp_service.pipeline_service_role_name
}

resource "aws_iam_role_policy" "deploy_production_monitoring_layer" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_production_monitoring_layer.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_production_migrations" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_production_migrations.pipeline_service_role_name
}

resource "aws_iam_role_policy" "apply_dev_sg_to_preprod" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.apply_dev_sg_to_preprod.pipeline_service_role_name
}

resource "aws_iam_role_policy" "remove_dev_sg_from_preprod" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.remove_dev_sg_from_preprod.pipeline_service_role_name
}

resource "aws_iam_role_policy" "apply_dev_sg_to_e2e_test" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.apply_dev_sg_to_e2e_test.pipeline_service_role_name
}

resource "aws_iam_role_policy" "remove_dev_sg_from_e2e_test" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.remove_dev_sg_from_e2e_test.pipeline_service_role_name
}
