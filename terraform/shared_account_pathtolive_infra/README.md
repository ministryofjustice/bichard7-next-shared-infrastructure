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
