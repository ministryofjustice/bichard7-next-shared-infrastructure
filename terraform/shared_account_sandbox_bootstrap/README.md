# Shared Account Sandbox Bootstrap

Configures a shared bucket for state and dynamodb table for terraform state management.
The state is not automatically persisted to s3, but can be retrieved from the key `bootstrap/terraform.tfstate`. Copy this using aws s3 cp prior to running terraform against the remote and copy it back once done

*NB!*
If we do not pull the state and persist it to the remote we will have to re-import all of the resources
from scratch.

To update:

```shell
$ aws-vault exec bichard7-sandbox-shared -- aws s3 cp s3://jse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate/bootstrap/terraform.tfstate terraform.tfstate
$ aws-vault exec bichard7-sandbox-shared -- terraform init -upgrade
$ aws-vault exec bichard7-sandbox-shared -- terraform apply
$ aws-vault exec bichard7-sandbox-shared -- aws s3 cp terraform.tfstate s3://cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate/bootstrap/terraform.tfstate
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 3.75.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_resources_terraform_remote_state"></a> [account\_resources\_terraform\_remote\_state](#module\_account\_resources\_terraform\_remote\_state) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/terraform_remote_state?ref=upgrade-aws-provider | n/a |
| <a name="module_aws_logs"></a> [aws\_logs](#module\_aws\_logs) | trussworks/logs/aws | ~> 10.3.0  |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_tag_vars"></a> [tag\_vars](#module\_tag\_vars) | github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/tag_vars?ref=upgrade-aws-provider | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_account_public_access_block.protect](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/resources/s3_account_public_access_block) | resource |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/3.75.2/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_terraform_remote_state"></a> [terraform\_remote\_state](#output\_terraform\_remote\_state) | n/a |
<!-- END_TF_DOCS -->
