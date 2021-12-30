# Shared Account Pathtolive Infra CI

Creates various codebuild/codepipeline jobs and a codebuild vpc for our path to live account

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.10 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.56.0 |
| <a name="provider_aws.integration_baseline"></a> [aws.integration\_baseline](#provider\_aws.integration\_baseline) | 3.56.0 |
| <a name="provider_aws.integration_next"></a> [aws.integration\_next](#provider\_aws.integration\_next) | 3.56.0 |
| <a name="provider_aws.production"></a> [aws.production](#provider\_aws.production) | 3.56.0 |
| <a name="provider_aws.qsolution"></a> [aws.qsolution](#provider\_aws.qsolution) | 3.56.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apply_dev_sg_to_e2e_test"></a> [apply\_dev\_sg\_to\_e2e\_test](#module\_apply\_dev\_sg\_to\_e2e\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_apply_dev_sg_to_int_test"></a> [apply\_dev\_sg\_to\_int\_test](#module\_apply\_dev\_sg\_to\_int\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_apply_dev_sg_to_load_test"></a> [apply\_dev\_sg\_to\_load\_test](#module\_apply\_dev\_sg\_to\_load\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_apply_dev_sg_to_preprod"></a> [apply\_dev\_sg\_to\_preprod](#module\_apply\_dev\_sg\_to\_preprod) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_apply_dev_sg_to_prod"></a> [apply\_dev\_sg\_to\_prod](#module\_apply\_dev\_sg\_to\_prod) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_build_nginx_scan_portal"></a> [build\_nginx\_scan\_portal](#module\_build\_nginx\_scan\_portal) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_codebuild_base_resources"></a> [codebuild\_base\_resources](#module\_codebuild\_base\_resources) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_base_resources | n/a |
| <a name="module_codebuild_docker_resources"></a> [codebuild\_docker\_resources](#module\_codebuild\_docker\_resources) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/aws_ecr_repositories | n/a |
| <a name="module_common_build_jobs"></a> [common\_build\_jobs](#module\_common\_build\_jobs) | ../modules/shared_cd_common_jobs | n/a |
| <a name="module_deploy_e2e_test_monitoring_layer"></a> [deploy\_e2e\_test\_monitoring\_layer](#module\_deploy\_e2e\_test\_monitoring\_layer) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_e2e_test_smtp_service"></a> [deploy\_e2e\_test\_smtp\_service](#module\_deploy\_e2e\_test\_smtp\_service) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_e2e_test_terraform"></a> [deploy\_e2e\_test\_terraform](#module\_deploy\_e2e\_test\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_integration_test_terraform"></a> [deploy\_integration\_test\_terraform](#module\_deploy\_integration\_test\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_load_test_monitoring_layer"></a> [deploy\_load\_test\_monitoring\_layer](#module\_deploy\_load\_test\_monitoring\_layer) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_load_test_terraform"></a> [deploy\_load\_test\_terraform](#module\_deploy\_load\_test\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_preprod_monitoring_layer"></a> [deploy\_preprod\_monitoring\_layer](#module\_deploy\_preprod\_monitoring\_layer) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_preprod_smtp_service"></a> [deploy\_preprod\_smtp\_service](#module\_deploy\_preprod\_smtp\_service) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_preprod_terraform"></a> [deploy\_preprod\_terraform](#module\_deploy\_preprod\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_production_monitoring_layer"></a> [deploy\_production\_monitoring\_layer](#module\_deploy\_production\_monitoring\_layer) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_production_smtp_service"></a> [deploy\_production\_smtp\_service](#module\_deploy\_production\_smtp\_service) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_deploy_production_terraform"></a> [deploy\_production\_terraform](#module\_deploy\_production\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_destroy_e2e_test_terraform"></a> [destroy\_e2e\_test\_terraform](#module\_destroy\_e2e\_test\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_destroy_integration_test_terraform"></a> [destroy\_integration\_test\_terraform](#module\_destroy\_integration\_test\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_destroy_load_test_terraform"></a> [destroy\_load\_test\_terraform](#module\_destroy\_load\_test\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_destroy_preprod_terraform"></a> [destroy\_preprod\_terraform](#module\_destroy\_preprod\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_destroy_production_terraform"></a> [destroy\_production\_terraform](#module\_destroy\_production\_terraform) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_ecs_scanning_portal"></a> [ecs\_scanning\_portal](#module\_ecs\_scanning\_portal) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules//scanning_results_ecs | n/a |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_notify_development_promotion_pipeline"></a> [notify\_development\_promotion\_pipeline](#module\_notify\_development\_promotion\_pipeline) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codestar_notification | n/a |
| <a name="module_notify_pipeline"></a> [notify\_pipeline](#module\_notify\_pipeline) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codestar_notification | n/a |
| <a name="module_owasp_scan_e2e_test"></a> [owasp\_scan\_e2e\_test](#module\_owasp\_scan\_e2e\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_owasp_scan_e2e_test_audit_logging"></a> [owasp\_scan\_e2e\_test\_audit\_logging](#module\_owasp\_scan\_e2e\_test\_audit\_logging) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_owasp_scan_e2e_test_audit_logging_trigger"></a> [owasp\_scan\_e2e\_test\_audit\_logging\_trigger](#module\_owasp\_scan\_e2e\_test\_audit\_logging\_trigger) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_owasp_scan_e2e_test_trigger"></a> [owasp\_scan\_e2e\_test\_trigger](#module\_owasp\_scan\_e2e\_test\_trigger) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_owasp_scan_e2e_test_user_service"></a> [owasp\_scan\_e2e\_test\_user\_service](#module\_owasp\_scan\_e2e\_test\_user\_service) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_owasp_scan_e2e_test_user_service_trigger"></a> [owasp\_scan\_e2e\_test\_user\_service\_trigger](#module\_owasp\_scan\_e2e\_test\_user\_service\_trigger) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_remove_dev_sg_from_e2e_test"></a> [remove\_dev\_sg\_from\_e2e\_test](#module\_remove\_dev\_sg\_from\_e2e\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_remove_dev_sg_from_e2e_test_schedule"></a> [remove\_dev\_sg\_from\_e2e\_test\_schedule](#module\_remove\_dev\_sg\_from\_e2e\_test\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_remove_dev_sg_from_int_test"></a> [remove\_dev\_sg\_from\_int\_test](#module\_remove\_dev\_sg\_from\_int\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_remove_dev_sg_from_int_test_schedule"></a> [remove\_dev\_sg\_from\_int\_test\_schedule](#module\_remove\_dev\_sg\_from\_int\_test\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_remove_dev_sg_from_load_test"></a> [remove\_dev\_sg\_from\_load\_test](#module\_remove\_dev\_sg\_from\_load\_test) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_remove_dev_sg_from_load_test_schedule"></a> [remove\_dev\_sg\_from\_load\_test\_schedule](#module\_remove\_dev\_sg\_from\_load\_test\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_remove_dev_sg_from_preprod"></a> [remove\_dev\_sg\_from\_preprod](#module\_remove\_dev\_sg\_from\_preprod) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_remove_dev_sg_from_preprod_schedule"></a> [remove\_dev\_sg\_from\_preprod\_schedule](#module\_remove\_dev\_sg\_from\_preprod\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_remove_dev_sg_from_prod"></a> [remove\_dev\_sg\_from\_prod](#module\_remove\_dev\_sg\_from\_prod) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_remove_dev_sg_from_prod_schedule"></a> [remove\_dev\_sg\_from\_prod\_schedule](#module\_remove\_dev\_sg\_from\_prod\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_reset_preprod_smtp_bastion"></a> [reset\_preprod\_smtp\_bastion](#module\_reset\_preprod\_smtp\_bastion) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_reset_preprod_smtp_bastion_schedule"></a> [reset\_preprod\_smtp\_bastion\_schedule](#module\_reset\_preprod\_smtp\_bastion\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_reset_production_smtp_bastion"></a> [reset\_production\_smtp\_bastion](#module\_reset\_production\_smtp\_bastion) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_reset_production_smtp_bastion_schedule"></a> [reset\_production\_smtp\_bastion\_schedule](#module\_reset\_production\_smtp\_bastion\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_run_destroy_load_test_env_schedule"></a> [run\_destroy\_load\_test\_env\_schedule](#module\_run\_destroy\_load\_test\_env\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_run_e2e_test_migrations"></a> [run\_e2e\_test\_migrations](#module\_run\_e2e\_test\_migrations) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_e2e_tests"></a> [run\_e2e\_tests](#module\_run\_e2e\_tests) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_e2e_tests_restart_pnc_container"></a> [run\_e2e\_tests\_restart\_pnc\_container](#module\_run\_e2e\_tests\_restart\_pnc\_container) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_e2e_tests_schedule"></a> [run\_e2e\_tests\_schedule](#module\_run\_e2e\_tests\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_run_integration_test_migrations"></a> [run\_integration\_test\_migrations](#module\_run\_integration\_test\_migrations) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_integration_tests"></a> [run\_integration\_tests](#module\_run\_integration\_tests) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_integration_tests_restart_pnc_container"></a> [run\_integration\_tests\_restart\_pnc\_container](#module\_run\_integration\_tests\_restart\_pnc\_container) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_load_test_migrations"></a> [run\_load\_test\_migrations](#module\_run\_load\_test\_migrations) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_load_tests"></a> [run\_load\_tests](#module\_run\_load\_tests) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_load_tests_terminate_pnc_container"></a> [run\_load\_tests\_terminate\_pnc\_container](#module\_run\_load\_tests\_terminate\_pnc\_container) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_preprod_migrations"></a> [run\_preprod\_migrations](#module\_run\_preprod\_migrations) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_preprod_tests"></a> [run\_preprod\_tests](#module\_run\_preprod\_tests) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_prod_smoketests"></a> [run\_prod\_smoketests](#module\_run\_prod\_smoketests) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_run_production_migrations"></a> [run\_production\_migrations](#module\_run\_production\_migrations) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_integration_baseline"></a> [scoutsuite\_scan\_integration\_baseline](#module\_scoutsuite\_scan\_integration\_baseline) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_integration_baseline_schedule"></a> [scoutsuite\_scan\_integration\_baseline\_schedule](#module\_scoutsuite\_scan\_integration\_baseline\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_scoutsuite_scan_integration_next"></a> [scoutsuite\_scan\_integration\_next](#module\_scoutsuite\_scan\_integration\_next) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_integration_next_schedule"></a> [scoutsuite\_scan\_integration\_next\_schedule](#module\_scoutsuite\_scan\_integration\_next\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_scoutsuite_scan_shared"></a> [scoutsuite\_scan\_shared](#module\_scoutsuite\_scan\_shared) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_shared_schedule"></a> [scoutsuite\_scan\_shared\_schedule](#module\_scoutsuite\_scan\_shared\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_self_signed_certificate"></a> [self\_signed\_certificate](#module\_self\_signed\_certificate) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/self_signed_certificate | n/a |
| <a name="module_tag_develop_release"></a> [tag\_develop\_release](#module\_tag\_develop\_release) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_tag_production_release"></a> [tag\_production\_release](#module\_tag\_production\_release) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_tag_rc_release"></a> [tag\_rc\_release](#module\_tag\_rc\_release) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_tag_vars"></a> [tag\_vars](#module\_tag\_vars) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars | n/a |
| <a name="module_update_environment_ssm_params"></a> [update\_environment\_ssm\_params](#module\_update\_environment\_ssm\_params) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.bichard7_pathtolive_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.base_infra_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_codebuild_webhook.e2e_tests_pr_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [aws_codepipeline.development_promotion_pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.path_to_live](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.rc_promotion_pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.develop_codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.rc_codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_e2e_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_load_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_pre_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_load_tests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_production_smoketests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_integration_baseline_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_integration_next_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_qsolution_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.apply_dev_sg_to_e2e_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.apply_dev_sg_to_preprod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.build_audit_logging_docker_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.build_auth_proxy_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.build_bichard7_application_docker_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.build_user_service_docker_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_e2e_test_monitoring_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_e2e_test_smtp_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_integration_test_terraform_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_load_test_monitoring_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_production_monitoring_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_production_smtp_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.develop_codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.remove_dev_sg_from_e2e_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.remove_dev_sg_from_preprod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.restart_pnc_emulator_e2e_tests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_e2e_test_migrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_e2e_tests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_integration_test_migrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_integration_tests_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_integration_tests_restart_pnc_container_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_load_test_migrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_preprod_migrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_preprod_tests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_production_migrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.tag_develop_release_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.tag_production_release_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.tag_rc_release_allow_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.update_e2e_test_ssm_params](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_user_policy.allow_ci_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_alias.codepipeline_deploy_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.codepipeline_deploy_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_route53_record.bichard7_name_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.bichard7_pathtolive_delegated_zone_validation_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.parent_zone_validation_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.codebuild_public_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.integration_baseline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.integration_next](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.preprod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_repository.bichard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_ecr_repository.nodejs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.latest_bichard_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.latest_nodejs_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [template_file.allow_codebuild_codestar_connection](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.codepipeline_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.develop_codepipeline_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.develop_kms_permissions](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.kms_permissions](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.shared_infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_is_cd"></a> [is\_cd](#input\_is\_cd) | Is this being run by CD | `bool` | `false` | no |
| <a name="input_slack_webhook"></a> [slack\_webhook](#input\_slack\_webhook) | Our webhook for sending messages to slack | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_resources"></a> [base\_resources](#output\_base\_resources) | The outputs for our base resources |
| <a name="output_bichard_liberty_ecr"></a> [bichard\_liberty\_ecr](#output\_bichard\_liberty\_ecr) | The Bichard Liberty ecr repository details |
| <a name="output_codebuild_cidr_block"></a> [codebuild\_cidr\_block](#output\_codebuild\_cidr\_block) | The cidr block for our codebuild vpc |
| <a name="output_codebuild_private_cidr_blocks"></a> [codebuild\_private\_cidr\_blocks](#output\_codebuild\_private\_cidr\_blocks) | A list of private cidr blocks |
| <a name="output_codebuild_public_cidr_blocks"></a> [codebuild\_public\_cidr\_blocks](#output\_codebuild\_public\_cidr\_blocks) | A list of private cidr blocks |
| <a name="output_codebuild_security_group_id"></a> [codebuild\_security\_group\_id](#output\_codebuild\_security\_group\_id) | The VPC security group id used by codebuild |
| <a name="output_codebuild_subnet_ids"></a> [codebuild\_subnet\_ids](#output\_codebuild\_subnet\_ids) | A list of private subnet ids |
| <a name="output_codebuild_vpc_id"></a> [codebuild\_vpc\_id](#output\_codebuild\_vpc\_id) | The vpc ID for our codebuild vpc |
| <a name="output_prometheus_cloudwatch_exporter_repository_arn"></a> [prometheus\_cloudwatch\_exporter\_repository\_arn](#output\_prometheus\_cloudwatch\_exporter\_repository\_arn) | The repository arn for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_cloudwatch_exporter_repository_url"></a> [prometheus\_cloudwatch\_exporter\_repository\_url](#output\_prometheus\_cloudwatch\_exporter\_repository\_url) | The repository url for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_repository_arn"></a> [prometheus\_repository\_arn](#output\_prometheus\_repository\_arn) | The repository arn for our prometheus image |
| <a name="output_prometheus_repository_url"></a> [prometheus\_repository\_url](#output\_prometheus\_repository\_url) | The repository url for our prometheus image |
| <a name="output_scanning_portal_fqdn"></a> [scanning\_portal\_fqdn](#output\_scanning\_portal\_fqdn) | The external fqdn of our scanning portal |
| <a name="output_staged_docker_resources"></a> [staged\_docker\_resources](#output\_staged\_docker\_resources) | The outputs from our staged docker images module |
<!-- END_TF_DOCS -->
