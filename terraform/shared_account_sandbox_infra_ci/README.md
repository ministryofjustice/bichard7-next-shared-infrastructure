# Shared Account Sandbox Infra CI

Creates various codebuild/codepipeline jobs and a codebuild vpc for our path to live account

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 3.72.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.72.0 |
| <a name="provider_aws.sandbox_a"></a> [aws.sandbox\_a](#provider\_aws.sandbox\_a) | 3.72.0 |
| <a name="provider_aws.sandbox_b"></a> [aws.sandbox\_b](#provider\_aws.sandbox\_b) | 3.72.0 |
| <a name="provider_aws.sandbox_c"></a> [aws.sandbox\_c](#provider\_aws.sandbox\_c) | 3.72.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apply_nuke_sandbox_schedule"></a> [apply\_nuke\_sandbox\_schedule](#module\_apply\_nuke\_sandbox\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_codebuild_base_resources"></a> [codebuild\_base\_resources](#module\_codebuild\_base\_resources) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_base_resources | n/a |
| <a name="module_codebuild_docker_resources"></a> [codebuild\_docker\_resources](#module\_codebuild\_docker\_resources) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/aws_ecr_repositories | n/a |
| <a name="module_common_build_jobs"></a> [common\_build\_jobs](#module\_common\_build\_jobs) | ../modules/shared_cd_common_jobs | n/a |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_nuke_sandbox"></a> [nuke\_sandbox](#module\_nuke\_sandbox) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_sandbox_a"></a> [scoutsuite\_scan\_sandbox\_a](#module\_scoutsuite\_scan\_sandbox\_a) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_sandbox_a_schedule"></a> [scoutsuite\_scan\_sandbox\_a\_schedule](#module\_scoutsuite\_scan\_sandbox\_a\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_scoutsuite_scan_sandbox_b"></a> [scoutsuite\_scan\_sandbox\_b](#module\_scoutsuite\_scan\_sandbox\_b) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_sandbox_b_schedule"></a> [scoutsuite\_scan\_sandbox\_b\_schedule](#module\_scoutsuite\_scan\_sandbox\_b\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_scoutsuite_scan_sandbox_c"></a> [scoutsuite\_scan\_sandbox\_c](#module\_scoutsuite\_scan\_sandbox\_c) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_sandbox_c_schedule"></a> [scoutsuite\_scan\_sandbox\_c\_schedule](#module\_scoutsuite\_scan\_sandbox\_c\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_scoutsuite_scan_shared"></a> [scoutsuite\_scan\_shared](#module\_scoutsuite\_scan\_shared) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job | n/a |
| <a name="module_scoutsuite_scan_shared_schedule"></a> [scoutsuite\_scan\_shared\_schedule](#module\_scoutsuite\_scan\_shared\_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule | n/a |
| <a name="module_tag_vars"></a> [tag\_vars](#module\_tag\_vars) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.codebuild_automation_dashboard](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_dashboard.codebuild_scanners_dashboard](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/cloudwatch_dashboard) | resource |
| [aws_iam_role_policy.allow_sandbox_a_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_sandbox_b_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_sandbox_c_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_user_policy.allow_ci_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/resources/iam_user_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sandbox_a](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sandbox_b](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sandbox_c](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/caller_identity) | data source |
| [aws_ecr_repository.was](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/ecr_repository) | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.72.0/docs/data-sources/region) | data source |
| [external_external.latest_was_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [template_file.codebuild_automation_dashboard](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.codebuild_scanners_dashboard](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
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
| <a name="output_codebuild_subnet_ids"></a> [codebuild\_subnet\_ids](#output\_codebuild\_subnet\_ids) | A list of private subnet ids |
| <a name="output_codebuild_vpc_id"></a> [codebuild\_vpc\_id](#output\_codebuild\_vpc\_id) | The vpc ID for our codebuild vpc |
| <a name="output_prometheus_cloudwatch_exporter_repository_arn"></a> [prometheus\_cloudwatch\_exporter\_repository\_arn](#output\_prometheus\_cloudwatch\_exporter\_repository\_arn) | The repository arn for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_cloudwatch_exporter_repository_url"></a> [prometheus\_cloudwatch\_exporter\_repository\_url](#output\_prometheus\_cloudwatch\_exporter\_repository\_url) | The repository url for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_repository_arn"></a> [prometheus\_repository\_arn](#output\_prometheus\_repository\_arn) | The repository arn for our prometheus image |
| <a name="output_prometheus_repository_url"></a> [prometheus\_repository\_url](#output\_prometheus\_repository\_url) | The repository url for our prometheus image |
| <a name="output_staged_docker_resources"></a> [staged\_docker\_resources](#output\_staged\_docker\_resources) | The outputs from our staged docker images module |
<!-- END_TF_DOCS -->
