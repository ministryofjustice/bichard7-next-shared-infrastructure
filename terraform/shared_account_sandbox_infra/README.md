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
| <a name="provider_aws"></a> [aws](#provider\_aws) | = 3.75.2 |
| <a name="provider_aws.sandbox_a"></a> [aws.sandbox\_a](#provider\_aws.sandbox\_a) | = 3.75.2 |
| <a name="provider_aws.sandbox_b"></a> [aws.sandbox\_b](#provider\_aws.sandbox\_b) | = 3.75.2 |
| <a name="provider_aws.sandbox_c"></a> [aws.sandbox\_c](#provider\_aws.sandbox\_c) | = 3.75.2 |
| <a name="provider_aws.sandbox_shared"></a> [aws.sandbox\_shared](#provider\_aws.sandbox\_shared) | = 3.75.2 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_logs"></a> [aws\_logs](#module\_aws\_logs) | trussworks/logs/aws | ~> 10.3.0  |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_sandbox_a_child_access"></a> [sandbox\_a\_child\_access](#module\_sandbox\_a\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_sandbox_b_child_access"></a> [sandbox\_b\_child\_access](#module\_sandbox\_b\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_sandbox_c_child_access"></a> [sandbox\_c\_child\_access](#module\_sandbox\_c\_child\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_child_access | n/a |
| <a name="module_shared_account_access_sandbox_a"></a> [shared\_account\_access\_sandbox\_a](#module\_shared\_account\_access\_sandbox\_a) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_access_sandbox_b"></a> [shared\_account\_access\_sandbox\_b](#module\_shared\_account\_access\_sandbox\_b) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_access_sandbox_c"></a> [shared\_account\_access\_sandbox\_c](#module\_shared\_account\_access\_sandbox\_c) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent_access | n/a |
| <a name="module_shared_account_user_access"></a> [shared\_account\_user\_access](#module\_shared\_account\_user\_access) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/shared_account_parent | n/a |
| <a name="module_tag_vars"></a> [tag\_vars](#module\_tag\_vars) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.allow_route53](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_policy) | resource |
| [aws_iam_role.allow_pathtolive_assume](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.allow_pathtolive_assume_route53](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.bichard7_dev_name_servers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record) | resource |
| [aws_route53_zone.bichard7_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone) | resource |
| [aws_route53_zone.bichard7_dev_delegated_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_zone) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sandbox_a](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sandbox_b](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sandbox_c](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity) | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region) | data source |
| [template_file.allow_route53](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_sandbox_a_access_key"></a> [sandbox\_a\_access\_key](#input\_sandbox\_a\_access\_key) | the AWS\_ACCESS\_KEY\_ID for sandbox\_a | `string` | n/a | yes |
| <a name="input_sandbox_a_secret_key"></a> [sandbox\_a\_secret\_key](#input\_sandbox\_a\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for sandbox\_a | `string` | n/a | yes |
| <a name="input_sandbox_b_access_key"></a> [sandbox\_b\_access\_key](#input\_sandbox\_b\_access\_key) | the AWS\_ACCESS\_KEY\_ID for sandbox\_b | `string` | n/a | yes |
| <a name="input_sandbox_b_secret_key"></a> [sandbox\_b\_secret\_key](#input\_sandbox\_b\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for sandbox\_b | `string` | n/a | yes |
| <a name="input_sandbox_c_access_key"></a> [sandbox\_c\_access\_key](#input\_sandbox\_c\_access\_key) | the AWS\_ACCESS\_KEY\_ID for sandbox\_c | `string` | n/a | yes |
| <a name="input_sandbox_c_secret_key"></a> [sandbox\_c\_secret\_key](#input\_sandbox\_c\_secret\_key) | the AWS\_SECRET\_ACCESS\_KEY for sandbox\_c | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_group_name"></a> [admin\_group\_name](#output\_admin\_group\_name) | The name of our admin group |
| <a name="output_allow_route53_assume_arn"></a> [allow\_route53\_assume\_arn](#output\_allow\_route53\_assume\_arn) | The arn for the path to live assume role |
| <a name="output_ci_group_name"></a> [ci\_group\_name](#output\_ci\_group\_name) | The name of our ci group |
| <a name="output_ci_users"></a> [ci\_users](#output\_ci\_users) | A list of our CI users |
| <a name="output_delegated_hosted_zone"></a> [delegated\_hosted\_zone](#output\_delegated\_hosted\_zone) | Our dev hosted zone |
| <a name="output_mfa_group_name"></a> [mfa\_group\_name](#output\_mfa\_group\_name) | The name of our MFA group |
| <a name="output_parent_delegated_hosted_zone"></a> [parent\_delegated\_hosted\_zone](#output\_parent\_delegated\_hosted\_zone) | Our delegated hosted zone |
| <a name="output_readonly_group_name"></a> [readonly\_group\_name](#output\_readonly\_group\_name) | The name of our readonly group |
| <a name="output_s3_logging_bucket_name"></a> [s3\_logging\_bucket\_name](#output\_s3\_logging\_bucket\_name) | The name of our shared logging bucket |
| <a name="output_sandbox_a_admin_arn"></a> [sandbox\_a\_admin\_arn](#output\_sandbox\_a\_admin\_arn) | The sandbox\_a Admin Assume Role ARN |
| <a name="output_sandbox_a_ci_arn"></a> [sandbox\_a\_ci\_arn](#output\_sandbox\_a\_ci\_arn) | The sandbox\_c CI Assume Role ARN |
| <a name="output_sandbox_a_readonly_arn"></a> [sandbox\_a\_readonly\_arn](#output\_sandbox\_a\_readonly\_arn) | The sandbox\_a ReadOnly Assume Role ARN |
| <a name="output_sandbox_b_admin_arn"></a> [sandbox\_b\_admin\_arn](#output\_sandbox\_b\_admin\_arn) | The sandbox\_b Admin Assume Role ARN |
| <a name="output_sandbox_b_ci_arn"></a> [sandbox\_b\_ci\_arn](#output\_sandbox\_b\_ci\_arn) | The sandbox\_b CI Assume Role ARN |
| <a name="output_sandbox_b_readonly_arn"></a> [sandbox\_b\_readonly\_arn](#output\_sandbox\_b\_readonly\_arn) | The sandbox\_b ReadOnly Assume Role ARN |
| <a name="output_sandbox_c_admin_arn"></a> [sandbox\_c\_admin\_arn](#output\_sandbox\_c\_admin\_arn) | The sandbox\_c Admin Assume Role ARN |
| <a name="output_sandbox_c_ci_arn"></a> [sandbox\_c\_ci\_arn](#output\_sandbox\_c\_ci\_arn) | The sandbox\_c CI Assume Role ARN |
| <a name="output_sandbox_c_readonly_arn"></a> [sandbox\_c\_readonly\_arn](#output\_sandbox\_c\_readonly\_arn) | The sandbox\_c ReadOnly Assume Role ARN |
| <a name="output_shared_ci_policy_arn"></a> [shared\_ci\_policy\_arn](#output\_shared\_ci\_policy\_arn) | The arn of our ci policy consumed by our codebuild jobs |
<!-- END_TF_DOCS -->
