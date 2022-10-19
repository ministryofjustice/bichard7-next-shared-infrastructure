# Shared Account Pathtolive Infra CI

Creates various codebuild/codepipeline jobs and a codebuild vpc for our path to live account

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 3.75.2 |
| <a name="requirement_local"></a> [local](#requirement_local)             | ~> 2.0.0 |

## Providers

| Name                                                                                                            | Version |
| --------------------------------------------------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                                                                | 3.75.2  |
| <a name="provider_aws.integration_baseline"></a> [aws.integration_baseline](#provider_aws.integration_baseline) | 3.75.2  |
| <a name="provider_aws.integration_next"></a> [aws.integration_next](#provider_aws.integration_next)             | 3.75.2  |
| <a name="provider_aws.production"></a> [aws.production](#provider_aws.production)                               | 3.75.2  |
| <a name="provider_aws.qsolution"></a> [aws.qsolution](#provider_aws.qsolution)                                  | 3.75.2  |
| <a name="provider_external"></a> [external](#provider_external)                                                 | 2.1.0   |
| <a name="provider_template"></a> [template](#provider_template)                                                 | 2.2.0   |
| <a name="provider_terraform"></a> [terraform](#provider_terraform)                                              | n/a     |

## Modules

| Name                                                                                                                                                                       | Source                                                                                                  | Version |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------- |
| <a name="module_apply_dev_sg_to_e2e_test"></a> [apply_dev_sg_to_e2e_test](#module_apply_dev_sg_to_e2e_test)                                                                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_apply_dev_sg_to_load_test"></a> [apply_dev_sg_to_load_test](#module_apply_dev_sg_to_load_test)                                                             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_apply_dev_sg_to_preprod"></a> [apply_dev_sg_to_preprod](#module_apply_dev_sg_to_preprod)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_apply_dev_sg_to_prod"></a> [apply_dev_sg_to_prod](#module_apply_dev_sg_to_prod)                                                                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_build_ci_monitoring"></a> [build_ci_monitoring](#module_build_ci_monitoring)                                                                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_build_ci_monitoring_schedule"></a> [build_ci_monitoring_schedule](#module_build_ci_monitoring_schedule)                                                    | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_build_nginx_scan_portal"></a> [build_nginx_scan_portal](#module_build_nginx_scan_portal)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_code_to_be_deployed"></a> [code_to_be_deployed](#module_code_to_be_deployed)                                                                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_codebuild_base_resources"></a> [codebuild_base_resources](#module_codebuild_base_resources)                                                                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_base_resources | n/a     |
| <a name="module_codebuild_docker_resources"></a> [codebuild_docker_resources](#module_codebuild_docker_resources)                                                          | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/aws_ecr_repositories     | n/a     |
| <a name="module_common_build_jobs"></a> [common_build_jobs](#module_common_build_jobs)                                                                                     | ../modules/shared_cd_common_jobs                                                                        | n/a     |
| <a name="module_deploy_e2e_test_terraform"></a> [deploy_e2e_test_terraform](#module_deploy_e2e_test_terraform)                                                             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_deploy_load_test_terraform"></a> [deploy_load_test_terraform](#module_deploy_load_test_terraform)                                                          | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_deploy_preprod_terraform"></a> [deploy_preprod_terraform](#module_deploy_preprod_terraform)                                                                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_deploy_production_terraform"></a> [deploy_production_terraform](#module_deploy_production_terraform)                                                       | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_destroy_e2e_test_terraform"></a> [destroy_e2e_test_terraform](#module_destroy_e2e_test_terraform)                                                          | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_destroy_load_test_terraform"></a> [destroy_load_test_terraform](#module_destroy_load_test_terraform)                                                       | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_destroy_preprod_terraform"></a> [destroy_preprod_terraform](#module_destroy_preprod_terraform)                                                             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_destroy_production_terraform"></a> [destroy_production_terraform](#module_destroy_production_terraform)                                                    | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_disable_maintenance_page_preprod"></a> [disable_maintenance_page_preprod](#module_disable_maintenance_page_preprod)                                        | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_disable_maintenance_page_prod"></a> [disable_maintenance_page_prod](#module_disable_maintenance_page_prod)                                                 | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_ecs_scanning_portal"></a> [ecs_scanning_portal](#module_ecs_scanning_portal)                                                                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules//scanning_results_ecs    | n/a     |
| <a name="module_enable_maintenance_page_preprod"></a> [enable_maintenance_page_preprod](#module_enable_maintenance_page_preprod)                                           | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_enable_maintenance_page_prod"></a> [enable_maintenance_page_prod](#module_enable_maintenance_page_prod)                                                    | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_label"></a> [label](#module_label)                                                                                                                         | cloudposse/label/null                                                                                   | 0.24.1  |
| <a name="module_notify_pipeline"></a> [notify_pipeline](#module_notify_pipeline)                                                                                           | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codestar_notification    | n/a     |
| <a name="module_owasp_scan_e2e_test"></a> [owasp_scan_e2e_test](#module_owasp_scan_e2e_test)                                                                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_owasp_scan_e2e_test_audit_logging"></a> [owasp_scan_e2e_test_audit_logging](#module_owasp_scan_e2e_test_audit_logging)                                     | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_owasp_scan_e2e_test_audit_logging_trigger"></a> [owasp_scan_e2e_test_audit_logging_trigger](#module_owasp_scan_e2e_test_audit_logging_trigger)             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_owasp_scan_e2e_test_trigger"></a> [owasp_scan_e2e_test_trigger](#module_owasp_scan_e2e_test_trigger)                                                       | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_owasp_scan_e2e_test_user_service"></a> [owasp_scan_e2e_test_user_service](#module_owasp_scan_e2e_test_user_service)                                        | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_owasp_scan_e2e_test_user_service_trigger"></a> [owasp_scan_e2e_test_user_service_trigger](#module_owasp_scan_e2e_test_user_service_trigger)                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_remove_dev_sg_from_e2e_test"></a> [remove_dev_sg_from_e2e_test](#module_remove_dev_sg_from_e2e_test)                                                       | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_remove_dev_sg_from_e2e_test_schedule"></a> [remove_dev_sg_from_e2e_test_schedule](#module_remove_dev_sg_from_e2e_test_schedule)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_remove_dev_sg_from_load_test"></a> [remove_dev_sg_from_load_test](#module_remove_dev_sg_from_load_test)                                                    | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_remove_dev_sg_from_preprod"></a> [remove_dev_sg_from_preprod](#module_remove_dev_sg_from_preprod)                                                          | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_remove_dev_sg_from_preprod_schedule"></a> [remove_dev_sg_from_preprod_schedule](#module_remove_dev_sg_from_preprod_schedule)                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_remove_dev_sg_from_prod"></a> [remove_dev_sg_from_prod](#module_remove_dev_sg_from_prod)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_remove_dev_sg_from_prod_schedule"></a> [remove_dev_sg_from_prod_schedule](#module_remove_dev_sg_from_prod_schedule)                                        | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_run_destroy_load_test_env_schedule"></a> [run_destroy_load_test_env_schedule](#module_run_destroy_load_test_env_schedule)                                  | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_run_e2e_test_migrations"></a> [run_e2e_test_migrations](#module_run_e2e_test_migrations)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_e2e_tests"></a> [run_e2e_tests](#module_run_e2e_tests)                                                                                                 | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_e2e_tests_restart_pnc_container"></a> [run_e2e_tests_restart_pnc_container](#module_run_e2e_tests_restart_pnc_container)                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_e2e_tests_schedule"></a> [run_e2e_tests_schedule](#module_run_e2e_tests_schedule)                                                                      | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_run_load_test_migrations"></a> [run_load_test_migrations](#module_run_load_test_migrations)                                                                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_load_tests"></a> [run_load_tests](#module_run_load_tests)                                                                                              | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_load_tests_terminate_pnc_container"></a> [run_load_tests_terminate_pnc_container](#module_run_load_tests_terminate_pnc_container)                      | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_preprod_migrations"></a> [run_preprod_migrations](#module_run_preprod_migrations)                                                                      | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_preprod_tests"></a> [run_preprod_tests](#module_run_preprod_tests)                                                                                     | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_prod_smoketests"></a> [run_prod_smoketests](#module_run_prod_smoketests)                                                                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_run_production_migrations"></a> [run_production_migrations](#module_run_production_migrations)                                                             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_integration_baseline"></a> [scoutsuite_scan_integration_baseline](#module_scoutsuite_scan_integration_baseline)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_integration_baseline_schedule"></a> [scoutsuite_scan_integration_baseline_schedule](#module_scoutsuite_scan_integration_baseline_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_scoutsuite_scan_integration_next"></a> [scoutsuite_scan_integration_next](#module_scoutsuite_scan_integration_next)                                        | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_integration_next_schedule"></a> [scoutsuite_scan_integration_next_schedule](#module_scoutsuite_scan_integration_next_schedule)             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_scoutsuite_scan_shared"></a> [scoutsuite_scan_shared](#module_scoutsuite_scan_shared)                                                                      | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_shared_schedule"></a> [scoutsuite_scan_shared_schedule](#module_scoutsuite_scan_shared_schedule)                                           | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_self_signed_certificate"></a> [self_signed_certificate](#module_self_signed_certificate)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/self_signed_certificate  | n/a     |
| <a name="module_tag_vars"></a> [tag_vars](#module_tag_vars)                                                                                                                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars                 | n/a     |
| <a name="module_update_environment_ssm_params"></a> [update_environment_ssm_params](#module_update_environment_ssm_params)                                                 | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |

## Resources

| Name                                                                                                                                                                        | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_acm_certificate.bichard7_pathtolive_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/acm_certificate)                       | resource    |
| [aws_acm_certificate_validation.base_infra_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/acm_certificate_validation)  | resource    |
| [aws_codebuild_webhook.e2e_tests_pr_webhook](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/codebuild_webhook)                                 | resource    |
| [aws_codepipeline.path_to_live](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/codepipeline)                                                   | resource    |
| [aws_codestarconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/codestarconnections_connection)                     | resource    |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role)                                                      | resource    |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_e2e_test](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)       | resource    |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_load_test](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)      | resource    |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_pre_prod](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)       | resource    |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_deploy_production](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)     | resource    |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_load_tests](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)            | resource    |
| [aws_iam_role_policy.allow_code_pipeline_connection_for_production_smoketests](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy) | resource    |
| [aws_iam_role_policy.allow_integration_baseline_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)              | resource    |
| [aws_iam_role_policy.allow_integration_next_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                  | resource    |
| [aws_iam_role_policy.allow_production_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                        | resource    |
| [aws_iam_role_policy.allow_qsolution_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                         | resource    |
| [aws_iam_role_policy.apply_dev_sg_to_e2e_test](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                 | resource    |
| [aws_iam_role_policy.apply_dev_sg_to_preprod](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                  | resource    |
| [aws_iam_role_policy.code_to_be_deployed](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                      | resource    |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                      | resource    |
| [aws_iam_role_policy.remove_dev_sg_from_e2e_test](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                              | resource    |
| [aws_iam_role_policy.remove_dev_sg_from_preprod](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                               | resource    |
| [aws_iam_role_policy.restart_pnc_emulator_e2e_tests](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                           | resource    |
| [aws_iam_role_policy.run_e2e_test_migrations](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                  | resource    |
| [aws_iam_role_policy.run_e2e_tests](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                            | resource    |
| [aws_iam_role_policy.run_load_test_migrations](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                 | resource    |
| [aws_iam_role_policy.run_preprod_migrations](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                   | resource    |
| [aws_iam_role_policy.run_preprod_tests](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                        | resource    |
| [aws_iam_role_policy.run_production_migrations](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                                | resource    |
| [aws_iam_role_policy.update_e2e_test_ssm_params](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                               | resource    |
| [aws_iam_user_policy.allow_ci_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_user_policy)                                      | resource    |
| [aws_iam_user_policy.allow_ci_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_user_policy)                                | resource    |
| [aws_kms_alias.codepipeline_deploy_key](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/kms_alias)                                              | resource    |
| [aws_kms_key.codepipeline_deploy_key](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/kms_key)                                                  | resource    |
| [aws_route53_record.bichard7_name_servers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record)                                      | resource    |
| [aws_route53_record.bichard7_pathtolive_delegated_zone_validation_records](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record)      | resource    |
| [aws_route53_record.parent_zone_validation_records](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record)                             | resource    |
| [aws_route53_zone.codebuild_public_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone)                                          | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                               | data source |
| [aws_caller_identity.integration_baseline](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                  | data source |
| [aws_caller_identity.integration_next](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                      | data source |
| [aws_caller_identity.preprod](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                               | data source |
| [aws_caller_identity.production](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                            | data source |
| [aws_ecr_repository.bichard](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ecr_repository)                                                 | data source |
| [aws_ecr_repository.codebuild_base](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ecr_repository)                                          | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region)                                                          | data source |
| [external_external.latest_bichard_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)                                      | data source |
| [external_external.latest_codebuild_base](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)                                     | data source |
| [template_file.allow_codebuild_codestar_connection](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                               | data source |
| [template_file.codepipeline_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                      | data source |
| [template_file.kms_permissions](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                                   | data source |
| [terraform_remote_state.shared_infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)                                    | data source |

## Inputs

| Name                                                                     | Description                               | Type     | Default | Required |
| ------------------------------------------------------------------------ | ----------------------------------------- | -------- | ------- | :------: |
| <a name="input_is_cd"></a> [is_cd](#input_is_cd)                         | Is this being run by CD                   | `bool`   | `false` |    no    |
| <a name="input_slack_webhook"></a> [slack_webhook](#input_slack_webhook) | Our webhook for sending messages to slack | `string` | `""`    |    no    |

## Outputs

| Name                                                                                                                                                                       | Description                                                     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| <a name="output_base_resources"></a> [base_resources](#output_base_resources)                                                                                              | The outputs for our base resources                              |
| <a name="output_bichard_liberty_ecr"></a> [bichard_liberty_ecr](#output_bichard_liberty_ecr)                                                                               | The Bichard Liberty ecr repository details                      |
| <a name="output_codebuild_cidr_block"></a> [codebuild_cidr_block](#output_codebuild_cidr_block)                                                                            | The cidr block for our codebuild vpc                            |
| <a name="output_codebuild_private_cidr_blocks"></a> [codebuild_private_cidr_blocks](#output_codebuild_private_cidr_blocks)                                                 | A list of private cidr blocks                                   |
| <a name="output_codebuild_private_subnet_ids"></a> [codebuild_private_subnet_ids](#output_codebuild_private_subnet_ids)                                                    | A list of all the subnet ids                                    |
| <a name="output_codebuild_public_cidr_blocks"></a> [codebuild_public_cidr_blocks](#output_codebuild_public_cidr_blocks)                                                    | A list of private cidr blocks                                   |
| <a name="output_codebuild_public_subnet_ids"></a> [codebuild_public_subnet_ids](#output_codebuild_public_subnet_ids)                                                       | A list of public subnet ids                                     |
| <a name="output_codebuild_security_group_id"></a> [codebuild_security_group_id](#output_codebuild_security_group_id)                                                       | The VPC security group id used by codebuild                     |
| <a name="output_codebuild_subnet_ids"></a> [codebuild_subnet_ids](#output_codebuild_subnet_ids)                                                                            | A list of all the subnet ids                                    |
| <a name="output_codebuild_vpc_id"></a> [codebuild_vpc_id](#output_codebuild_vpc_id)                                                                                        | The vpc ID for our codebuild vpc                                |
| <a name="output_codebuild_zone_id"></a> [codebuild_zone_id](#output_codebuild_zone_id)                                                                                     | The public zone id for our codebuild VPC route53 zone           |
| <a name="output_codepipeline_bucket"></a> [codepipeline_bucket](#output_codepipeline_bucket)                                                                               | The name of the codebuild/pipeline bucket                       |
| <a name="output_prometheus_cloudwatch_exporter_repository_arn"></a> [prometheus_cloudwatch_exporter_repository_arn](#output_prometheus_cloudwatch_exporter_repository_arn) | The repository arn for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_cloudwatch_exporter_repository_url"></a> [prometheus_cloudwatch_exporter_repository_url](#output_prometheus_cloudwatch_exporter_repository_url) | The repository url for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_repository_arn"></a> [prometheus_repository_arn](#output_prometheus_repository_arn)                                                             | The repository arn for our prometheus image                     |
| <a name="output_prometheus_repository_url"></a> [prometheus_repository_url](#output_prometheus_repository_url)                                                             | The repository url for our prometheus image                     |
| <a name="output_scanning_portal_fqdn"></a> [scanning_portal_fqdn](#output_scanning_portal_fqdn)                                                                            | The external fqdn of our scanning portal                        |
| <a name="output_ssl_certificate_arn"></a> [ssl_certificate_arn](#output_ssl_certificate_arn)                                                                               | The arn for our ACM ssl certificate                             |
| <a name="output_staged_docker_resources"></a> [staged_docker_resources](#output_staged_docker_resources)                                                                   | The outputs from our staged docker images module                |

<!-- END_TF_DOCS -->
