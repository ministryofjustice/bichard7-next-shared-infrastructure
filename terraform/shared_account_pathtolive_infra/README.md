# Shared Account Path to Live Infrastructure

Configures child/parent relationships as well as roles across our shared accounts

Prior to running this ensure that you have the following variables exported

```shell
export TF_VAR_integration_next_access_key=""
export TF_VAR_integration_next_secret_key=""
export TF_VAR_integration_baseline_access_key=""
export TF_VAR_integration_baseline_secret_key=""
export TF_VAR_preprod_access_key=""
export TF_VAR_preprod_secret_key=""
export TF_VAR_preprod_session_token=""
export TF_VAR_production_access_key=""
export TF_VAR_production_secret_key=""
export TF_VAR_production_session_token=""
```

The preprod and production access keys can be acquired by sourcing the `get_qsolution_sts_tokens.sh` script in the
`bichard7-next-infrastructure` repository. These require you to have an account set up on the Q-Solution parent and have
a `qsolutions-auth` profile set up in Aws-Vault. You will also need `jq` installed.

For the delegated hosted zone parent see [this readme](../shared_account_sandbox_infra/README.md)

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 3.75.2 |
| <a name="requirement_local"></a> [local](#requirement_local)             | ~> 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement_null)                | ~> 3.0.0 |
| <a name="requirement_template"></a> [template](#requirement_template)    | ~> 2.2.0 |
| <a name="requirement_tls"></a> [tls](#requirement_tls)                   | ~> 3.1.0 |

## Providers

| Name                                                                                                            | Version  |
| --------------------------------------------------------------------------------------------------------------- | -------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                                                                | = 3.75.2 |
| <a name="provider_aws.integration_baseline"></a> [aws.integration_baseline](#provider_aws.integration_baseline) | = 3.75.2 |
| <a name="provider_aws.integration_next"></a> [aws.integration_next](#provider_aws.integration_next)             | = 3.75.2 |
| <a name="provider_aws.preprod"></a> [aws.preprod](#provider_aws.preprod)                                        | = 3.75.2 |
| <a name="provider_aws.production"></a> [aws.production](#provider_aws.production)                               | = 3.75.2 |
| <a name="provider_aws.sandbox"></a> [aws.sandbox](#provider_aws.sandbox)                                        | = 3.75.2 |
| <a name="provider_aws.shared"></a> [aws.shared](#provider_aws.shared)                                           | = 3.75.2 |

## Modules

| Name                                                                                                                                                                                                                    | Source                                                                                                      | Version   |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | --------- |
| <a name="module_aws_logs"></a> [aws_logs](#module_aws_logs)                                                                                                                                                             | trussworks/logs/aws                                                                                         | ~> 10.3.0 |
| <a name="module_integration_baseline_child_access"></a> [integration_baseline_child_access](#module_integration_baseline_child_access)                                                                                  | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_integration_next_child_access"></a> [integration_next_child_access](#module_integration_next_child_access)                                                                                              | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_label"></a> [label](#module_label)                                                                                                                                                                      | cloudposse/label/null                                                                                       | 0.24.1    |
| <a name="module_preprod_child_access"></a> [preprod_child_access](#module_preprod_child_access)                                                                                                                         | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_production_child_access"></a> [production_child_access](#module_production_child_access)                                                                                                                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_shared_account_access_integration_baseline"></a> [shared_account_access_integration_baseline](#module_shared_account_access_integration_baseline)                                                       | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_access_integration_baseline_lambda_cloudtrail"></a> [shared_account_access_integration_baseline_lambda_cloudtrail](#module_shared_account_access_integration_baseline_lambda_cloudtrail) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail            | n/a       |
| <a name="module_shared_account_access_integration_next"></a> [shared_account_access_integration_next](#module_shared_account_access_integration_next)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_access_integration_next_lambda_cloudtrail"></a> [shared_account_access_integration_next_lambda_cloudtrail](#module_shared_account_access_integration_next_lambda_cloudtrail)             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail            | n/a       |
| <a name="module_shared_account_access_preprod"></a> [shared_account_access_preprod](#module_shared_account_access_preprod)                                                                                              | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_access_production"></a> [shared_account_access_production](#module_shared_account_access_production)                                                                                     | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_preprod_lambda_cloudtrail"></a> [shared_account_preprod_lambda_cloudtrail](#module_shared_account_preprod_lambda_cloudtrail)                                                             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail            | n/a       |
| <a name="module_shared_account_production_next_lambda_cloudtrail"></a> [shared_account_production_next_lambda_cloudtrail](#module_shared_account_production_next_lambda_cloudtrail)                                     | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail            | n/a       |
| <a name="module_shared_account_user_access"></a> [shared_account_user_access](#module_shared_account_user_access)                                                                                                       | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent        | n/a       |
| <a name="module_tag_vars"></a> [tag_vars](#module_tag_vars)                                                                                                                                                             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars                     | n/a       |

## Resources

| Name                                                                                                                                              | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_route53_record.bichard7_pathtolive_name_servers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record) | resource    |
| [aws_route53_zone.bichard7_pathtolive_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone)   | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                     | data source |
| [aws_caller_identity.integration_baseline](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)        | data source |
| [aws_caller_identity.integration_next](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)            | data source |
| [aws_caller_identity.preprod](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                     | data source |
| [aws_caller_identity.production](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                  | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region)                                | data source |
| [aws_ssm_parameter.non_sc_users](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ssm_parameter)                    | data source |

## Inputs

| Name                                                                                                                           | Description                                         | Type     | Default                   | Required |
| ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------- | -------- | ------------------------- | :------: |
| <a name="input_integration_baseline_access_key"></a> [integration_baseline_access_key](#input_integration_baseline_access_key) | the AWS_ACCESS_KEY_ID for integration_baseline      | `string` | n/a                       |   yes    |
| <a name="input_integration_baseline_secret_key"></a> [integration_baseline_secret_key](#input_integration_baseline_secret_key) | the AWS_SECRET_ACCESS_KEY for integration_baseline  | `string` | n/a                       |   yes    |
| <a name="input_integration_next_access_key"></a> [integration_next_access_key](#input_integration_next_access_key)             | the AWS_ACCESS_KEY_ID for integration_next          | `string` | n/a                       |   yes    |
| <a name="input_integration_next_secret_key"></a> [integration_next_secret_key](#input_integration_next_secret_key)             | the AWS_SECRET_ACCESS_KEY for integration_next      | `string` | n/a                       |   yes    |
| <a name="input_parent_zone_id"></a> [parent_zone_id](#input_parent_zone_id)                                                    | The zone id of our parent hosted zone               | `string` | `"Z0532960253T16WMNSRNR"` |    no    |
| <a name="input_preprod_access_key"></a> [preprod_access_key](#input_preprod_access_key)                                        | the AWS_ACCESS_KEY_ID for Q Solution preprod        | `string` | n/a                       |   yes    |
| <a name="input_preprod_secret_key"></a> [preprod_secret_key](#input_preprod_secret_key)                                        | the AWS_SECRET_ACCESS_KEY for Q Solution preprod    | `string` | n/a                       |   yes    |
| <a name="input_preprod_session_token"></a> [preprod_session_token](#input_preprod_session_token)                               | the AWS_SESSION_TOKEN for Q Solution preprod        | `string` | n/a                       |   yes    |
| <a name="input_production_access_key"></a> [production_access_key](#input_production_access_key)                               | the AWS_ACCESS_KEY_ID for Q Solution production     | `string` | n/a                       |   yes    |
| <a name="input_production_secret_key"></a> [production_secret_key](#input_production_secret_key)                               | the AWS_SECRET_ACCESS_KEY for Q Solution production | `string` | n/a                       |   yes    |
| <a name="input_production_session_token"></a> [production_session_token](#input_production_session_token)                      | the AWS_SESSION_TOKEN for Q Solution production     | `string` | n/a                       |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                                            | The AWS region                                      | `string` | `"eu-west-2"`             |    no    |
| <a name="input_slack_webhook"></a> [slack_webhook](#input_slack_webhook)                                                       | Our webhook for sending messages to slack           | `string` | `""`                      |    no    |

## Outputs

| Name                                                                                                                                   | Description                                             |
| -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| <a name="output_admin_group_name"></a> [admin_group_name](#output_admin_group_name)                                                    | The name of our admin group                             |
| <a name="output_ci_group_name"></a> [ci_group_name](#output_ci_group_name)                                                             | The name of our ci group                                |
| <a name="output_ci_users"></a> [ci_users](#output_ci_users)                                                                            | A list of our CI users                                  |
| <a name="output_delegated_hosted_zone"></a> [delegated_hosted_zone](#output_delegated_hosted_zone)                                     | Our pathtolive hosted zone                              |
| <a name="output_integration_baseline_admin_arn"></a> [integration_baseline_admin_arn](#output_integration_baseline_admin_arn)          | The integration_baseline Admin Assume Role ARN          |
| <a name="output_integration_baseline_ci_arn"></a> [integration_baseline_ci_arn](#output_integration_baseline_ci_arn)                   | The integration_baseline CI Assume Role ARN             |
| <a name="output_integration_baseline_readonly_arn"></a> [integration_baseline_readonly_arn](#output_integration_baseline_readonly_arn) | The integration_baseline ReadOnly Assume Role ARN       |
| <a name="output_integration_next_admin_arn"></a> [integration_next_admin_arn](#output_integration_next_admin_arn)                      | The integration_next Admin Assume Role ARN              |
| <a name="output_integration_next_ci_arn"></a> [integration_next_ci_arn](#output_integration_next_ci_arn)                               | The integration_next CI Assume Role ARN                 |
| <a name="output_integration_next_readonly_arn"></a> [integration_next_readonly_arn](#output_integration_next_readonly_arn)             | The integration_next ReadOnly Assume Role ARN           |
| <a name="output_mfa_group_name"></a> [mfa_group_name](#output_mfa_group_name)                                                          | The name of our MFA group                               |
| <a name="output_preprod_admin_arn"></a> [preprod_admin_arn](#output_preprod_admin_arn)                                                 | The preprod Admin Assume Role ARN                       |
| <a name="output_preprod_ci_arn"></a> [preprod_ci_arn](#output_preprod_ci_arn)                                                          | The preprod CI Assume Role ARN                          |
| <a name="output_production_admin_arn"></a> [production_admin_arn](#output_production_admin_arn)                                        | The production Admin Assume Role ARN                    |
| <a name="output_production_ci_arn"></a> [production_ci_arn](#output_production_ci_arn)                                                 | The production CI Assume Role ARN                       |
| <a name="output_readonly_group_name"></a> [readonly_group_name](#output_readonly_group_name)                                           | The name of our readonly group                          |
| <a name="output_s3_logging_bucket_name"></a> [s3_logging_bucket_name](#output_s3_logging_bucket_name)                                  | The name of our shared logging bucket                   |
| <a name="output_shared_ci_policy_arn"></a> [shared_ci_policy_arn](#output_shared_ci_policy_arn)                                        | The arn of our ci policy consumed by our codebuild jobs |

<!-- END_TF_DOCS -->
