resource "aws_iam_role" "develop_codepipeline_role" {
  name = "cjse-bichard7-develop-build-role"

  assume_role_policy = file("${path.module}/policies/codepipeline_policy.json")
}

data "template_file" "develop_codepipeline_policy_template" {
  template = file("${path.module}/policies/codepipeline_role_policy.json")

  vars = {
    account_id    = data.aws_caller_identity.current.account_id
    region        = data.aws_region.current_region.name
    bucket_arn    = module.codebuild_base_resources.codepipeline_bucket_arn
    sns_topic_arn = module.codebuild_base_resources.notifications_arn
  }
}

resource "aws_iam_role_policy" "develop_codepipeline_policy" {
  name = "cjse-bichard7-develop-deploy-policy"
  role = aws_iam_role.develop_codepipeline_role.id

  policy = data.template_file.codepipeline_policy_template.rendered
}

data "template_file" "develop_kms_permissions" {
  template = file("${path.module}/policies/codebuild_kms_permissions.json")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}

#### Pipeline permissions
resource "aws_iam_role_policy" "build_bichard7_application_docker_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.common_build_jobs.build_bichard7_application_service_role_name
}

resource "aws_iam_role_policy" "build_user_service_docker_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.common_build_jobs.build_user_service_service_role_name
}

resource "aws_iam_role_policy" "build_audit_logging_docker_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.common_build_jobs.build_audit_logging_service_role_name
}

resource "aws_iam_role_policy" "tag_develop_release_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.tag_develop_release.pipeline_service_role_name
}

resource "aws_iam_role_policy" "tag_rc_release_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.tag_rc_release.pipeline_service_role_name
}

resource "aws_iam_role_policy" "tag_production_release_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.tag_production_release.pipeline_service_role_name
}

resource "aws_iam_role_policy" "build_auth_proxy_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.common_build_jobs.build_auth_proxy_service_role_name
}

resource "aws_iam_role_policy" "deploy_integration_test_terraform_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.deploy_integration_test_terraform.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_integration_tests_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_integration_tests.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_integration_tests_restart_pnc_container_allow_codestar" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_integration_tests_restart_pnc_container.pipeline_service_role_name
}

resource "aws_iam_role_policy" "run_integration_test_migrations" {
  name   = "allow-codestar-connection"
  policy = data.template_file.allow_codebuild_codestar_connection.rendered
  role   = module.run_integration_test_migrations.pipeline_service_role_name
}
