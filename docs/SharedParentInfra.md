## Shared Account Parent Infrastructure

##### Bootstrap Layer
This layer sets up the prerequisites for all terraform runs.

```shell
$ cd terraform/shared_account_(pathtolive/sandbox)_bootstrap
$ aws-vault exec your-shared-parent-credentials -- terraform init -upgrade
$ aws-vault exec your-shared-parent-credentials -- aws s3 cp s3://bucket/bootstrap/terraform.tfstate terraform.tfstate
$ aws-vault exec your-shared-parent-credentials -- terraform state apply
$ aws-vault exec your-shared-parent-credentials -- aws s3 cp terraform.tfstate s3://bucket/bootstrap/terraform.tfstate
```

##### Shared Infra Layer

This layer sets up IAM roles and cross account access.

Ensure you have aws credentials exported for the relevant accounts. For sandbox you will
need the following vars

```shell
export TF_VAR_sandbox_a_access_key=""
export TF_VAR_sandbox_a_secret_key=""
export TF_VAR_sandbox_b_access_key=""
export TF_VAR_sandbox_b_secret_key=""
export TF_VAR_sandbox_c_access_key=""
export TF_VAR_sandbox_c_secret_key=""
```

For pathtolive  the production and preprod keys require you to have an account
on the vendor PAAS shared account. Once you have this set up and have the aws keys
set up in vault as `qsolutions-auth` run the following:- `source ../bichard7-next-infrastructure/scripts/get_qsolution_sts_tokens.sh`.

This will export the production/preprod keys.

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

I have found it useful to export my keys into any session by adding the export commands to my ~/.bashrc file

ie
```shell
#... truncated .bashrc
export TF_VAR_sandbox_a_access_key=""
export TF_VAR_sandbox_b_access_key=""
export TF_VAR_sandbox_c_access_key=""
export TF_VAR_parent_secret_key=""
export TF_VAR_sandbox_a_secret_key=""
export TF_VAR_sandbox_b_secret_key=""
export TF_VAR_sandbox_c_secret_key=""
export TF_VAR_integration_next_access_key=""
export TF_VAR_integration_next_secret_key=""
export TF_VAR_integration_baseline_access_key=""
export TF_VAR_integration_baseline_secret_key=""
```

To apply the layer
```shell
$ source ../bichard7-next-infra/scripts/get_qsolution_sts_tokens.sh # Optional
$ cd terraform/shared_account_(pathtolive/sandbox)_infra
$ aws-vault exec your-shared-parent-credentials -- terraform init -upgrade
$ aws-vault exec your-shared-parent-credentials -- terraform state apply
```

##### Shared Infra CI Layer

This layer will configure all the codebuild jobs and supporting infrastructure required by them.
see [this document](./SharedCICD.md) for more information.

All of the shared jobs are in the [modules subdirectory](../terraform/modules/shared_cd_common_jobs/README.md).

To apply the layer. Please note you need docker installed locally for this to work.
```shell
$ cd terraform/shared_account_(pathtolive/sandbox)_infra_ci
$ aws-vault exec your-shared-parent-credentials -- terraform init -upgrade
$ aws-vault exec your-shared-parent-credentials -- terraform state apply
```
