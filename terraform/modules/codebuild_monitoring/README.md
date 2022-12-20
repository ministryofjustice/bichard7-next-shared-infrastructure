# Codebuild Monitoring Cluster

Provisions a monitoring cluster with the following components

- Grafana

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13  |
| <a name="requirement_archive"></a> [archive](#requirement_archive)       | = 2.2.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 3.75.2 |
| <a name="requirement_grafana"></a> [grafana](#requirement_grafana)       | 1.19.0   |
| <a name="requirement_local"></a> [local](#requirement_local)             | = 2.0.0  |
| <a name="requirement_template"></a> [template](#requirement_template)    | = 2.2.0  |
| <a name="requirement_time"></a> [time](#requirement_time)                | 0.7.2    |

## Providers

| Name                                                            | Version |
| --------------------------------------------------------------- | ------- |
| <a name="provider_archive"></a> [archive](#provider_archive)    | 2.2.0   |
| <a name="provider_aws"></a> [aws](#provider_aws)                | 3.75.2  |
| <a name="provider_grafana"></a> [grafana](#provider_grafana)    | 1.19.0  |
| <a name="provider_random"></a> [random](#provider_random)       | 3.4.3   |
| <a name="provider_template"></a> [template](#provider_template) | 2.2.0   |
| <a name="provider_time"></a> [time](#provider_time)             | 0.7.2   |

## Modules

| Name                                                                                                                                | Source                                                                                         | Version |
| ----------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| <a name="module_codebuild_monitoring_ecs_alb"></a> [codebuild_monitoring_ecs_alb](#module_codebuild_monitoring_ecs_alb)             | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/ecs_cluster_alb | n/a     |
| <a name="module_codebuild_monitoring_ecs_cluster"></a> [codebuild_monitoring_ecs_cluster](#module_codebuild_monitoring_ecs_cluster) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/ecs_cluster     | n/a     |

## Resources

| Name                                                                                                                                                                  | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_event_rule.codebuild_metrics_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/cloudwatch_event_rule)               | resource    |
| [aws_cloudwatch_event_target.codebuild_metrics_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/cloudwatch_event_target)           | resource    |
| [aws_cloudwatch_log_group.codebuild_monitoring](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/cloudwatch_log_group)                     | resource    |
| [aws_db_subnet_group.grafana_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/db_subnet_group)                               | resource    |
| [aws_iam_role.codebuild_metrics_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role)                                         | resource    |
| [aws_iam_role_policy.allow_ecs_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                               | resource    |
| [aws_iam_role_policy.codebuild_metrics_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/iam_role_policy)                           | resource    |
| [aws_kms_alias.aurora_cluster_encryption_key_alias](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/kms_alias)                            | resource    |
| [aws_kms_alias.logging_encryption_key_alias](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/kms_alias)                                   | resource    |
| [aws_kms_key.aurora_cluster_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/kms_key)                                      | resource    |
| [aws_kms_key.logging_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/kms_key)                                             | resource    |
| [aws_lambda_function.codebuild_metrics_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/lambda_function)                           | resource    |
| [aws_lambda_permission.allow_cloudwatch_to_call_check_foo](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/lambda_permission)             | resource    |
| [aws_rds_cluster.grafana_db](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/rds_cluster)                                                 | resource    |
| [aws_rds_cluster_instance.grafana_db_instance](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/rds_cluster_instance)                      | resource    |
| [aws_route53_record.grafana_public_record](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/route53_record)                                | resource    |
| [aws_security_group.grafana_alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group)                           | resource    |
| [aws_security_group.grafana_cluster_security_group](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group)                       | resource    |
| [aws_security_group.grafana_db_security_group](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group)                            | resource    |
| [aws_security_group_rule.allow_db_ingress_from_grafana_containers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)   | resource    |
| [aws_security_group_rule.allow_grafana_alb_http_ingress](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)             | resource    |
| [aws_security_group_rule.allow_grafana_alb_https_egress_to_grafana](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)  | resource    |
| [aws_security_group_rule.allow_grafana_alb_https_ingress](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)            | resource    |
| [aws_security_group_rule.allow_grafana_alb_https_ingress_to_grafana](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule) | resource    |
| [aws_security_group_rule.allow_grafana_container_egress_to_world](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)    | resource    |
| [aws_security_group_rule.allow_grafana_egress_to_db](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/security_group_rule)                 | resource    |
| [aws_ssm_parameter.admin_password](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                         | resource    |
| [aws_ssm_parameter.grafana_admin_api_key](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                  | resource    |
| [aws_ssm_parameter.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                 | resource    |
| [aws_ssm_parameter.grafana_admin_username](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                 | resource    |
| [aws_ssm_parameter.grafana_db_password](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                    | resource    |
| [aws_ssm_parameter.grafana_db_username](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                    | resource    |
| [aws_ssm_parameter.grafana_secret_key](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                     | resource    |
| [aws_ssm_parameter.readonly_password](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/ssm_parameter)                                      | resource    |
| [grafana_api_key.admin_api_key](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/api_key)                                                | resource    |
| [grafana_dashboard.codebuild_dashboard](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/dashboard)                                      | resource    |
| [grafana_dashboard.codebuild_ecs_stats](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/dashboard)                                      | resource    |
| [grafana_dashboard.codebuild_last_build_status_dashboard](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/dashboard)                    | resource    |
| [grafana_dashboard.codebuild_status_dashboard](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/dashboard)                               | resource    |
| [grafana_data_source.cloudwatch](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/data_source)                                           | resource    |
| [grafana_user.admin_user](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/user)                                                         | resource    |
| [grafana_user.readonly_user](https://registry.terraform.io/providers/grafana/grafana/1.19.0/docs/resources/user)                                                      | resource    |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)                                             | resource    |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)                                     | resource    |
| [random_password.grafana_db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)                                        | resource    |
| [random_password.readonly_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)                                          | resource    |
| [random_string.grafana_admin_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                           | resource    |
| [random_string.grafana_dbuser](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                                 | resource    |
| [random_string.grafana_secret_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                             | resource    |
| [time_sleep.wait_for_containers](https://registry.terraform.io/providers/hashicorp/time/0.7.2/docs/resources/sleep)                                                   | resource    |
| [archive_file.codebuild_metrics_payload](https://registry.terraform.io/providers/hashicorp/archive/2.2.0/docs/data-sources/file)                                      | data source |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/availability_zones)                                   | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/caller_identity)                                         | data source |
| [aws_iam_group.admins](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/iam_group)                                                      | data source |
| [aws_iam_group.viewers](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/iam_group)                                                     | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region)                                                           | data source |
| [aws_route53_zone.public_zone](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/route53_zone)                                           | data source |
| [template_file.allow_kms_access](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file)                                             | data source |
| [template_file.codebuild_metrics_permissions](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file)                                | data source |
| [template_file.grafana_ecs_task](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file)                                             | data source |

## Inputs

| Name                                                                                                         | Description                                                           | Type           | Default           | Required |
| ------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- | -------------- | ----------------- | :------: |
| <a name="input_fargate_cpu"></a> [fargate_cpu](#input_fargate_cpu)                                           | The number of cpu units                                               | `number`       | `1024`            |    no    |
| <a name="input_fargate_memory"></a> [fargate_memory](#input_fargate_memory)                                  | The amount of memory that will be given to fargate in Megabytes       | `number`       | `2048`            |    no    |
| <a name="input_grafana_db_instance_class"></a> [grafana_db_instance_class](#input_grafana_db_instance_class) | The class of DB instance we are using for Grafana                     | `string`       | `"db.t4g.medium"` |    no    |
| <a name="input_grafana_db_instance_count"></a> [grafana_db_instance_count](#input_grafana_db_instance_count) | The number of DB instance we are using for Grafana                    | `number`       | `3`               |    no    |
| <a name="input_grafana_image"></a> [grafana_image](#input_grafana_image)                                     | The url of our grafana ecs image we want to use                       | `string`       | n/a               |   yes    |
| <a name="input_grafana_repository_arn"></a> [grafana_repository_arn](#input_grafana_repository_arn)          | The arn of our grafana repository                                     | `string`       | n/a               |   yes    |
| <a name="input_idle_timeout"></a> [idle_timeout](#input_idle_timeout)                                        | How long in seconds before we terminate a connection                  | `number`       | `180`             |    no    |
| <a name="input_logging_bucket_name"></a> [logging_bucket_name](#input_logging_bucket_name)                   | The default logging bucket for lb access logs                         | `string`       | n/a               |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                | The deployments name                                                  | `string`       | n/a               |   yes    |
| <a name="input_private_subnets"></a> [private_subnets](#input_private_subnets)                               | The private subnets to deploy our db into                             | `list(string)` | n/a               |   yes    |
| <a name="input_public_zone_id"></a> [public_zone_id](#input_public_zone_id)                                  | The zone id for our public hosted zone so we can use ACM certificates | `string`       | n/a               |   yes    |
| <a name="input_remote_exec_enabled"></a> [remote_exec_enabled](#input_remote_exec_enabled)                   | Do we want to allow remote-exec onto these containers                 | `bool`         | `true`            |    no    |
| <a name="input_service_subnets"></a> [service_subnets](#input_service_subnets)                               | A list of our subnets                                                 | `list(string)` | n/a               |   yes    |
| <a name="input_ssl_certificate_arn"></a> [ssl_certificate_arn](#input_ssl_certificate_arn)                   | The arn of our acm certificate                                        | `string`       | n/a               |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                | A map of environment tags                                             | `map(string)`  | `{}`              |    no    |
| <a name="input_using_smtp_service"></a> [using_smtp_service](#input_using_smtp_service)                      | Are we using the CJSM smtp service                                    | `bool`         | `false`           |    no    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                          | The vpc id for our security groups to bind to                         | `string`       | n/a               |   yes    |

## Outputs

| Name                                                                                                                 | Description                                           |
| -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| <a name="output_grafana_admin_user_name"></a> [grafana_admin_user_name](#output_grafana_admin_user_name)             | The user name of our grafana admin                    |
| <a name="output_grafana_admin_user_password"></a> [grafana_admin_user_password](#output_grafana_admin_user_password) | The password of our grafana admin                     |
| <a name="output_grafana_api_key"></a> [grafana_api_key](#output_grafana_api_key)                                     | The api key we can use to provision grafana resources |
| <a name="output_grafana_external_fqdn"></a> [grafana_external_fqdn](#output_grafana_external_fqdn)                   | The public dns record for our grafana server          |

<!-- END_TF_DOCS -->
