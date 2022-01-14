## Shared Account Sandbox Users

Manages user access to AWS

Required tags

AdminAccess group users require the tag `"user-role" = "operations"` and readonly require the tag `"user-role" = "readonly""`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 3.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.72.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_tag_vars"></a> [tag\_vars](#module\_tag\_vars) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_user.ben_pirt](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user.brett_minnie](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user.emad_karamad](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user.jamie_davies](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user.jazz_sarkaria](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user.mihai_popa_matai](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user.simon_oldham](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.ben_pirt](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.brett_minnie](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.emad_karamad](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.jamie_davies](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.jazz_sarkaria](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.mihai_popa_matai](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.simon_oldham](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_group_membership) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_group.admin_group](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/iam_group) | data source |
| [aws_iam_group.mfa_group](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/iam_group) | data source |
| [aws_iam_group.readonly_group](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/iam_group) | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/region) | data source |
| [aws_ssm_parameter.ben_pirt](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.brett_minnie](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.emad_karamad](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.jamie_davies](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.jazz_sarkaria](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.mihai_popa_matai](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.simon_oldham](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.shared_infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_users"></a> [admin\_users](#output\_admin\_users) | A list of admin users |
| <a name="output_readonly_users"></a> [readonly\_users](#output\_readonly\_users) | A list of read-only users |
<!-- END_TF_DOCS -->
