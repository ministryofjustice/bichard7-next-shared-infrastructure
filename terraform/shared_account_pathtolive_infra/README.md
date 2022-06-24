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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 3.75.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.2 |
| <a name="provider_aws.integration_baseline"></a> [aws.integration\_baseline](#provider\_aws.integration\_baseline) | 3.75.2 |
| <a name="provider_aws.integration_next"></a> [aws.integration\_next](#provider\_aws.integration\_next) | 3.75.2 |
| <a name="provider_aws.preprod"></a> [aws.preprod](#provider\_aws.preprod) | 3.75.2 |
| <a name="provider_aws.production"></a> [aws.production](#provider\_aws.production) | 3.75.2 |
| <a name="provider_aws.sandbox"></a> [aws.sandbox](#provider\_aws.sandbox) | 3.75.2 |
| <a name="provider_aws.shared"></a> [aws.shared](#provider\_aws.shared) | 3.75.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_logs"></a> [aws\_logs](#module\_aws\_logs) | trussworks/logs/aws | ~> 10.3.0  |
| <a name="module_integration_baseline_child_access"></a> [integration\_baseline\_child\_access](#module\_integration\_baseline\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_integration_next_child_access"></a> [integration\_next\_child\_access](#module\_integration\_next\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_preprod_child_access"></a> [preprod\_child\_access](#module\_preprod\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_production_child_access"></a> [production\_child\_access](#module\_production\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_shared_account_access_integration_baseline"></a> [shared\_account\_access\_integration\_baseline](#module\_shared\_account\_access\_integration\_baseline) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_access_integration_baseline_lambda_cloudtrail"></a> [shared\_account\_access\_integration\_baseline\_lambda\_cloudtrail](#module\_shared\_account\_access\_integration\_baseline\_lambda\_cloudtrail) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail | n/a |
| <a name="module_shared_account_access_integration_next"></a> [shared\_account\_access\_integration\_next](#module\_shared\_account\_access\_integration\_next) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_access_integration_next_lambda_cloudtrail"></a> [shared\_account\_access\_integration\_next\_lambda\_cloudtrail](#module\_shared\_account\_access\_integration\_next\_lambda\_cloudtrail) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail | n/a |
| <a name="module_shared_account_access_preprod"></a> [shared\_account\_access\_preprod](#module\_shared\_account\_access\_preprod) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_access_production"></a> [shared\_account\_access\_production](#module\_shared\_account\_access\_production) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_preprod_lambda_cloudtrail"></a> [shared\_account\_preprod\_lambda\_cloudtrail](#module\_shared\_account\_preprod\_lambda\_cloudtrail) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail | n/a |
| <a name="module_shared_account_production_next_lambda_cloudtrail"></a> [shared\_account\_production\_next\_lambda\_cloudtrail](#module\_shared\_account\_production\_next\_lambda\_cloudtrail) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_cloudtrail | n/a |
| <a name="module_shared_account_user_access"></a> [shared\_account\_user\_access](#module\_shared\_account\_user\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent | n/a |
| <a name="module_tag_vars"></a> [tag\_vars](#module\_tag\_vars) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.bichard7_pathtolive_name_servers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record) | resource |
| [aws_route53_zone.bichard7_pathtolive_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.integration_baseline](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.integration_next](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.preprod](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.production](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region) | data source |
| [aws_ssm_parameter.non_sc_users](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_integration_baseline_access_key"></a> [integration\_baseline\_access\_key](#input\_integration\_baseline\_access\_key) | the AWS\_ACCESS\_KEY\_ID for integration\_baseline | `string` | n/a | yes |
| <a name="input_integration_baseline_secret_key"></a> [integration\_baseline\_secret\_key](#input\_integration\_baseline\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for integration\_baseline | `string` | n/a | yes |
| <a name="input_integration_next_access_key"></a> [integration\_next\_access\_key](#input\_integration\_next\_access\_key) | the AWS\_ACCESS\_KEY\_ID for integration\_next | `string` | n/a | yes |
| <a name="input_integration_next_secret_key"></a> [integration\_next\_secret\_key](#input\_integration\_next\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for integration\_next | `string` | n/a | yes |
| <a name="input_parent_zone_id"></a> [parent\_zone\_id](#input\_parent\_zone\_id) | The zone id of our parent hosted zone | `string` | `"Z0532960253T16WMNSRNR"` | no |
| <a name="input_preprod_access_key"></a> [preprod\_access\_key](#input\_preprod\_access\_key) | the AWS\_ACCESS\_KEY\_ID for Q Solution preprod | `string` | n/a | yes |
| <a name="input_preprod_secret_key"></a> [preprod\_secret\_key](#input\_preprod\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for Q Solution preprod | `string` | n/a | yes |
| <a name="input_preprod_session_token"></a> [preprod\_session\_token](#input\_preprod\_session\_token) | the AWS\_SESSION\_TOKEN for Q Solution preprod | `string` | n/a | yes |
| <a name="input_production_access_key"></a> [production\_access\_key](#input\_production\_access\_key) | the AWS\_ACCESS\_KEY\_ID for Q Solution production | `string` | n/a | yes |
| <a name="input_production_secret_key"></a> [production\_secret\_key](#input\_production\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for Q Solution production | `string` | n/a | yes |
| <a name="input_production_session_token"></a> [production\_session\_token](#input\_production\_session\_token) | the AWS\_SESSION\_TOKEN for Q Solution production | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_slack_webhook"></a> [slack\_webhook](#input\_slack\_webhook) | Our webhook for sending messages to slack | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_group_name"></a> [admin\_group\_name](#output\_admin\_group\_name) | The name of our admin group |
| <a name="output_ci_group_name"></a> [ci\_group\_name](#output\_ci\_group\_name) | The name of our ci group |
| <a name="output_ci_users"></a> [ci\_users](#output\_ci\_users) | A list of our CI users |
| <a name="output_delegated_hosted_zone"></a> [delegated\_hosted\_zone](#output\_delegated\_hosted\_zone) | Our pathtolive hosted zone |
| <a name="output_integration_baseline_admin_arn"></a> [integration\_baseline\_admin\_arn](#output\_integration\_baseline\_admin\_arn) | The integration\_baseline Admin Assume Role ARN |
| <a name="output_integration_baseline_ci_arn"></a> [integration\_baseline\_ci\_arn](#output\_integration\_baseline\_ci\_arn) | The integration\_baseline CI Assume Role ARN |
| <a name="output_integration_baseline_readonly_arn"></a> [integration\_baseline\_readonly\_arn](#output\_integration\_baseline\_readonly\_arn) | The integration\_baseline ReadOnly Assume Role ARN |
| <a name="output_integration_next_admin_arn"></a> [integration\_next\_admin\_arn](#output\_integration\_next\_admin\_arn) | The integration\_next Admin Assume Role ARN |
| <a name="output_integration_next_ci_arn"></a> [integration\_next\_ci\_arn](#output\_integration\_next\_ci\_arn) | The integration\_next CI Assume Role ARN |
| <a name="output_integration_next_readonly_arn"></a> [integration\_next\_readonly\_arn](#output\_integration\_next\_readonly\_arn) | The integration\_next ReadOnly Assume Role ARN |
| <a name="output_mfa_group_name"></a> [mfa\_group\_name](#output\_mfa\_group\_name) | The name of our MFA group |
| <a name="output_preprod_admin_arn"></a> [preprod\_admin\_arn](#output\_preprod\_admin\_arn) | The preprod Admin Assume Role ARN |
| <a name="output_preprod_ci_arn"></a> [preprod\_ci\_arn](#output\_preprod\_ci\_arn) | The preprod CI Assume Role ARN |
| <a name="output_production_admin_arn"></a> [production\_admin\_arn](#output\_production\_admin\_arn) | The production Admin Assume Role ARN |
| <a name="output_production_ci_arn"></a> [production\_ci\_arn](#output\_production\_ci\_arn) | The production CI Assume Role ARN |
| <a name="output_readonly_group_name"></a> [readonly\_group\_name](#output\_readonly\_group\_name) | The name of our readonly group |
| <a name="output_s3_logging_bucket_name"></a> [s3\_logging\_bucket\_name](#output\_s3\_logging\_bucket\_name) | The name of our shared logging bucket |
| <a name="output_shared_ci_policy_arn"></a> [shared\_ci\_policy\_arn](#output\_shared\_ci\_policy\_arn) | The arn of our ci policy consumed by our codebuild jobs |
<!-- END_TF_DOCS -->
