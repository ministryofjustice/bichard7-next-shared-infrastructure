# Shared Account Pathtolive Infra CI Monitoring

Creates a Grafana ECS cluster that pulls metrics from Cloudwatch

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 3.75.2 |
| <a name="requirement_local"></a> [local](#requirement_local)             | = 2.0.0  |

## Providers

| Name                                                               | Version |
| ------------------------------------------------------------------ | ------- |
| <a name="provider_archive"></a> [archive](#provider_archive)       | 2.2.0   |
| <a name="provider_aws"></a> [aws](#provider_aws)                   | 3.75.2  |
| <a name="provider_external"></a> [external](#provider_external)    | 2.2.3   |
| <a name="provider_terraform"></a> [terraform](#provider_terraform) | n/a     |

## Modules

| Name                                                                                            | Source                                                                                              | Version |
| ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------- |
| <a name="module_codebuild_monitoring"></a> [codebuild_monitoring](#module_codebuild_monitoring) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_monitoring | n/a     |
| <a name="module_label"></a> [label](#module_label)                                              | cloudposse/label/null                                                                               | 0.24.1  |
| <a name="module_lambda_slack_webhook"></a> [lambda_slack_webhook](#module_lambda_slack_webhook) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_slack_webhook | n/a     |
| <a name="module_tag_vars"></a> [tag_vars](#module_tag_vars)                                     | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars             | n/a     |

## Resources

| Name                                                                                                                                                             | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_event_rule.query_ecr_images_cron_schedule](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/cloudwatch_event_rule)    | resource    |
| [aws_cloudwatch_event_target.query_ecr_images_every_hour](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/cloudwatch_event_target)   | resource    |
| [aws_cloudwatch_metric_alarm.query_ecr_repo_images](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/cloudwatch_metric_alarm)         | resource    |
| [aws_iam_policy.lambda_allow_to_list_images](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_policy)                             | resource    |
| [aws_iam_policy.lambda_num_of_repos_manage_ec2_network_interfaces](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_policy)       | resource    |
| [aws_iam_role.ecr_repo_images](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role)                                             | resource    |
| [aws_lambda_function.query_images_fn](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/lambda_function)                               | resource    |
| [aws_lambda_permission.allow_cloudwatch_to_invoke_query_ecr_repo](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/lambda_permission) | resource    |
| [aws_security_group.slack_lambda_access_to_internet](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group)                 | resource    |
| [aws_security_group_rule.resource_to_internet_egress](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)           | resource    |
| [archive_file.query_num_ecr_images](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                                     | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                    | data source |
| [aws_ecr_repository.grafana_codebuild](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/ecr_repository)                            | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region)                                               | data source |
| [external_external.latest_grafana_codebuild_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)                 | data source |
| [terraform_remote_state.shared_infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)                         | data source |
| [terraform_remote_state.shared_infra_ci](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)                      | data source |

## Inputs

No inputs.

## Outputs

| Name                                                                 | Description                   |
| -------------------------------------------------------------------- | ----------------------------- |
| <a name="output_grafana_url"></a> [grafana_url](#output_grafana_url) | The url of our grafana server |

<!-- END_TF_DOCS -->
