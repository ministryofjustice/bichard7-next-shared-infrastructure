# Shared Account Sandbox Infra CI

Creates various codebuild/codepipeline jobs and a codebuild vpc for our path to live account

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 3.75.2 |
| <a name="requirement_local"></a> [local](#requirement_local)             | ~> 2.0.0 |

## Providers

| Name                                                                           | Version |
| ------------------------------------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                               | 3.75.2  |
| <a name="provider_aws.sandbox_a"></a> [aws.sandbox_a](#provider_aws.sandbox_a) | 3.75.2  |
| <a name="provider_aws.sandbox_b"></a> [aws.sandbox_b](#provider_aws.sandbox_b) | 3.75.2  |
| <a name="provider_aws.sandbox_c"></a> [aws.sandbox_c](#provider_aws.sandbox_c) | 3.75.2  |
| <a name="provider_external"></a> [external](#provider_external)                | 2.1.0   |
| <a name="provider_terraform"></a> [terraform](#provider_terraform)             | n/a     |

## Modules

| Name                                                                                                                                      | Source                                                                                                  | Version |
| ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------- |
| <a name="module_apply_nuke_sandbox_schedule"></a> [apply_nuke_sandbox_schedule](#module_apply_nuke_sandbox_schedule)                      | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_codebuild_base_resources"></a> [codebuild_base_resources](#module_codebuild_base_resources)                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_base_resources | n/a     |
| <a name="module_codebuild_docker_resources"></a> [codebuild_docker_resources](#module_codebuild_docker_resources)                         | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/aws_ecr_repositories     | n/a     |
| <a name="module_common_build_jobs"></a> [common_build_jobs](#module_common_build_jobs)                                                    | ../modules/shared_cd_common_jobs                                                                        | n/a     |
| <a name="module_label"></a> [label](#module_label)                                                                                        | cloudposse/label/null                                                                                   | 0.24.1  |
| <a name="module_nuke_sandbox"></a> [nuke_sandbox](#module_nuke_sandbox)                                                                   | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_sandbox_a"></a> [scoutsuite_scan_sandbox_a](#module_scoutsuite_scan_sandbox_a)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_sandbox_a_schedule"></a> [scoutsuite_scan_sandbox_a_schedule](#module_scoutsuite_scan_sandbox_a_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_scoutsuite_scan_sandbox_b"></a> [scoutsuite_scan_sandbox_b](#module_scoutsuite_scan_sandbox_b)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_sandbox_b_schedule"></a> [scoutsuite_scan_sandbox_b_schedule](#module_scoutsuite_scan_sandbox_b_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_scoutsuite_scan_sandbox_c"></a> [scoutsuite_scan_sandbox_c](#module_scoutsuite_scan_sandbox_c)                            | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_sandbox_c_schedule"></a> [scoutsuite_scan_sandbox_c_schedule](#module_scoutsuite_scan_sandbox_c_schedule) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_scoutsuite_scan_shared"></a> [scoutsuite_scan_shared](#module_scoutsuite_scan_shared)                                     | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job            | n/a     |
| <a name="module_scoutsuite_scan_shared_schedule"></a> [scoutsuite_scan_shared_schedule](#module_scoutsuite_scan_shared_schedule)          | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule       | n/a     |
| <a name="module_tag_vars"></a> [tag_vars](#module_tag_vars)                                                                               | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars                 | n/a     |

## Resources

| Name                                                                                                                                                | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_role_policy.allow_sandbox_a_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy) | resource    |
| [aws_iam_role_policy.allow_sandbox_b_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy) | resource    |
| [aws_iam_role_policy.allow_sandbox_c_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy) | resource    |
| [aws_iam_user_policy.allow_ci_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_user_policy)              | resource    |
| [aws_iam_user_policy.allow_ci_codebuild_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_user_policy)        | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                       | data source |
| [aws_caller_identity.sandbox_a](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                     | data source |
| [aws_caller_identity.sandbox_b](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                     | data source |
| [aws_caller_identity.sandbox_c](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                     | data source |
| [aws_ecr_repository.codebuild_base](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ecr_repository)                  | data source |
| [aws_ecr_repository.was](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ecr_repository)                             | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region)                                  | data source |
| [external_external.latest_codebuild_base](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)             | data source |
| [external_external.latest_was_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)                  | data source |
| [terraform_remote_state.shared_infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)            | data source |

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
| <a name="output_codebuild_subnet_ids"></a> [codebuild_subnet_ids](#output_codebuild_subnet_ids)                                                                            | A list of private subnet ids                                    |
| <a name="output_codebuild_vpc_id"></a> [codebuild_vpc_id](#output_codebuild_vpc_id)                                                                                        | The vpc ID for our codebuild vpc                                |
| <a name="output_prometheus_cloudwatch_exporter_repository_arn"></a> [prometheus_cloudwatch_exporter_repository_arn](#output_prometheus_cloudwatch_exporter_repository_arn) | The repository arn for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_cloudwatch_exporter_repository_url"></a> [prometheus_cloudwatch_exporter_repository_url](#output_prometheus_cloudwatch_exporter_repository_url) | The repository url for our prometheus cloudwatch exporter image |
| <a name="output_prometheus_repository_arn"></a> [prometheus_repository_arn](#output_prometheus_repository_arn)                                                             | The repository arn for our prometheus image                     |
| <a name="output_prometheus_repository_url"></a> [prometheus_repository_url](#output_prometheus_repository_url)                                                             | The repository url for our prometheus image                     |
| <a name="output_staged_docker_resources"></a> [staged_docker_resources](#output_staged_docker_resources)                                                                   | The outputs from our staged docker images module                |

<!-- END_TF_DOCS -->
