# Shared Account Sandbox Infrastructure

Configures child/parent relationships as well as roles across our shared accounts

Prior to running this ensure that you have the following variables exported

### Delegated hosted zones

MoJ have provided us with a top level delegated hosted zone, this is created in
this layer and the shared delegated zone for dev environments is created from this.
Furthermore, we allow the pathtolive account access to a role, which allows it to update dns
entries as it has a hosted zone that is delegated from the base MoJ zone.

The name servers for the delegated zone, must exist as a NS entry in the parent zone for it
to be searchable via dns.

```shell
export TF_VAR_sandbox_a_access_key=""
export TF_VAR_sandbox_a_secret_key=""
export TF_VAR_sandbox_b_access_key=""
export TF_VAR_sandbox_b_secret_key=""
export TF_VAR_sandbox_c_access_key=""
export TF_VAR_sandbox_c_secret_key=""
```

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

| Name                                                                                          | Version |
| --------------------------------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                                              | 3.75.2  |
| <a name="provider_aws.sandbox_a"></a> [aws.sandbox_a](#provider_aws.sandbox_a)                | 3.75.2  |
| <a name="provider_aws.sandbox_b"></a> [aws.sandbox_b](#provider_aws.sandbox_b)                | 3.75.2  |
| <a name="provider_aws.sandbox_c"></a> [aws.sandbox_c](#provider_aws.sandbox_c)                | 3.75.2  |
| <a name="provider_aws.sandbox_shared"></a> [aws.sandbox_shared](#provider_aws.sandbox_shared) | 3.75.2  |
| <a name="provider_template"></a> [template](#provider_template)                               | 2.2.0   |

## Modules

| Name                                                                                                                             | Source                                                                                                      | Version   |
| -------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | --------- |
| <a name="module_aws_logs"></a> [aws_logs](#module_aws_logs)                                                                      | trussworks/logs/aws                                                                                         | ~> 10.3.0 |
| <a name="module_label"></a> [label](#module_label)                                                                               | cloudposse/label/null                                                                                       | 0.24.1    |
| <a name="module_sandbox_a_child_access"></a> [sandbox_a_child_access](#module_sandbox_a_child_access)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_sandbox_b_child_access"></a> [sandbox_b_child_access](#module_sandbox_b_child_access)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_sandbox_c_child_access"></a> [sandbox_c_child_access](#module_sandbox_c_child_access)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access  | n/a       |
| <a name="module_shared_account_access_sandbox_a"></a> [shared_account_access_sandbox_a](#module_shared_account_access_sandbox_a) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_access_sandbox_b"></a> [shared_account_access_sandbox_b](#module_shared_account_access_sandbox_b) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_access_sandbox_c"></a> [shared_account_access_sandbox_c](#module_shared_account_access_sandbox_c) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a       |
| <a name="module_shared_account_user_access"></a> [shared_account_user_access](#module_shared_account_user_access)                | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent        | n/a       |
| <a name="module_tag_vars"></a> [tag_vars](#module_tag_vars)                                                                      | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars                     | n/a       |

## Resources

| Name                                                                                                                                                                     | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_iam_policy.allow_route53](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_policy)                                                   | resource    |
| [aws_iam_role.allow_pathtolive_assume](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role)                                             | resource    |
| [aws_iam_role_policy_attachment.allow_pathtolive_assume_route53](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_route53_record.bichard7_dev_name_servers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record)                               | resource    |
| [aws_route53_zone.bichard7_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone)                                     | resource    |
| [aws_route53_zone.bichard7_dev_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone)                                 | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                            | data source |
| [aws_caller_identity.sandbox_a](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                          | data source |
| [aws_caller_identity.sandbox_b](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                          | data source |
| [aws_caller_identity.sandbox_c](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                          | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region)                                                       | data source |
| [template_file.allow_route53](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                                  | data source |

## Inputs

| Name                                                                                          | Description                             | Type     | Default       | Required |
| --------------------------------------------------------------------------------------------- | --------------------------------------- | -------- | ------------- | :------: |
| <a name="input_region"></a> [region](#input_region)                                           | The AWS region                          | `string` | `"eu-west-2"` |    no    |
| <a name="input_sandbox_a_access_key"></a> [sandbox_a_access_key](#input_sandbox_a_access_key) | the AWS_ACCESS_KEY_ID for sandbox_a     | `string` | n/a           |   yes    |
| <a name="input_sandbox_a_secret_key"></a> [sandbox_a_secret_key](#input_sandbox_a_secret_key) | the AWS_SECRET_ACCESS_KEY for sandbox_a | `string` | n/a           |   yes    |
| <a name="input_sandbox_b_access_key"></a> [sandbox_b_access_key](#input_sandbox_b_access_key) | the AWS_ACCESS_KEY_ID for sandbox_b     | `string` | n/a           |   yes    |
| <a name="input_sandbox_b_secret_key"></a> [sandbox_b_secret_key](#input_sandbox_b_secret_key) | the AWS_SECRET_ACCESS_KEY for sandbox_b | `string` | n/a           |   yes    |
| <a name="input_sandbox_c_access_key"></a> [sandbox_c_access_key](#input_sandbox_c_access_key) | the AWS_ACCESS_KEY_ID for sandbox_c     | `string` | n/a           |   yes    |
| <a name="input_sandbox_c_secret_key"></a> [sandbox_c_secret_key](#input_sandbox_c_secret_key) | the AWS_SECRET_ACCESS_KEY for sandbox_c | `string` | n/a           |   yes    |

## Outputs

| Name                                                                                                                    | Description                                             |
| ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| <a name="output_admin_group_name"></a> [admin_group_name](#output_admin_group_name)                                     | The name of our admin group                             |
| <a name="output_allow_route53_assume_arn"></a> [allow_route53_assume_arn](#output_allow_route53_assume_arn)             | The arn for the path to live assume role                |
| <a name="output_ci_group_name"></a> [ci_group_name](#output_ci_group_name)                                              | The name of our ci group                                |
| <a name="output_ci_users"></a> [ci_users](#output_ci_users)                                                             | A list of our CI users                                  |
| <a name="output_delegated_hosted_zone"></a> [delegated_hosted_zone](#output_delegated_hosted_zone)                      | Our dev hosted zone                                     |
| <a name="output_mfa_group_name"></a> [mfa_group_name](#output_mfa_group_name)                                           | The name of our MFA group                               |
| <a name="output_parent_delegated_hosted_zone"></a> [parent_delegated_hosted_zone](#output_parent_delegated_hosted_zone) | Our delegated hosted zone                               |
| <a name="output_readonly_group_name"></a> [readonly_group_name](#output_readonly_group_name)                            | The name of our readonly group                          |
| <a name="output_s3_logging_bucket_name"></a> [s3_logging_bucket_name](#output_s3_logging_bucket_name)                   | The name of our shared logging bucket                   |
| <a name="output_sandbox_a_admin_arn"></a> [sandbox_a_admin_arn](#output_sandbox_a_admin_arn)                            | The sandbox_a Admin Assume Role ARN                     |
| <a name="output_sandbox_a_ci_arn"></a> [sandbox_a_ci_arn](#output_sandbox_a_ci_arn)                                     | The sandbox_c CI Assume Role ARN                        |
| <a name="output_sandbox_a_readonly_arn"></a> [sandbox_a_readonly_arn](#output_sandbox_a_readonly_arn)                   | The sandbox_a ReadOnly Assume Role ARN                  |
| <a name="output_sandbox_b_admin_arn"></a> [sandbox_b_admin_arn](#output_sandbox_b_admin_arn)                            | The sandbox_b Admin Assume Role ARN                     |
| <a name="output_sandbox_b_ci_arn"></a> [sandbox_b_ci_arn](#output_sandbox_b_ci_arn)                                     | The sandbox_b CI Assume Role ARN                        |
| <a name="output_sandbox_b_readonly_arn"></a> [sandbox_b_readonly_arn](#output_sandbox_b_readonly_arn)                   | The sandbox_b ReadOnly Assume Role ARN                  |
| <a name="output_sandbox_c_admin_arn"></a> [sandbox_c_admin_arn](#output_sandbox_c_admin_arn)                            | The sandbox_c Admin Assume Role ARN                     |
| <a name="output_sandbox_c_ci_arn"></a> [sandbox_c_ci_arn](#output_sandbox_c_ci_arn)                                     | The sandbox_c CI Assume Role ARN                        |
| <a name="output_sandbox_c_readonly_arn"></a> [sandbox_c_readonly_arn](#output_sandbox_c_readonly_arn)                   | The sandbox_c ReadOnly Assume Role ARN                  |
| <a name="output_shared_ci_policy_arn"></a> [shared_ci_policy_arn](#output_shared_ci_policy_arn)                         | The arn of our ci policy consumed by our codebuild jobs |

<!-- END_TF_DOCS -->
