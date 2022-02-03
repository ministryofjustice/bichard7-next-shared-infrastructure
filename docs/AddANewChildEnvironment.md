## How to add a new child environment

We use a parent child relationship with all of our accounts. The parent account hosts the users, ci/cd jobs, deployable
artifacts (ecr images and pre-compiled lambdas) and a delegated hosted zone parent and allows us to assume roles into
the child environments to perform various actions. The terraform state of all deployments is also hosted on the parent
account in a s3 bucket and dynamodb table.

Firstly we need a new aws account provisioned for us. Once we have that account we can then start the
bootstrapping process.

### Bootstrapping the shared environment

  - Log into the account's console, create yourself a user with Admin privileges,and create an access key pair via the console. Download this and make a note of the account ID and alias.
  - For this example we shall assume we have created a new environment with the alias of `integration_account`.
  - Add a new set of variables with the alias name to the relevant shared_account_infra `variables.tf` file. ie:-
    - integration_account_access_key - this will contain the AWS_ACCESS_KEY_ID from the keypair
    - integration_account_secret_key - this will contain the AWS_SECRET_ACCESS_KEY from the keypair
  - Export the newly created key prefixing the variable names with `TF_VAR_` ie:-
    - ```shell
         export TF_VAR_integration_account_access_key="XXXX"
         export TF_VAR_integration_account_secret_key="YYYY"
      ```
  - in `providers.tf` create a new provider using the new account alias as a description
    - ```hcl
        provider "aws" {
          region     = data.aws_region.current_region.name
          access_key = var.integration_account_access_key
          secret_key = var.integration_account_secret_key
          alias      = "integration_account"
      }
      ```
  - Create an `integration_account.tf` file, this will contain consume 2 modules see [this file](../terraform/shared_account_pathtolive_infra/integration_baseline.tf) as an example
  - In `outputs.tf` output the following role arns, as they can be consumed by other layers
    - `integration_account_ci_arn`
    - `integration_account_admin_arn`
    - `integration_account_readonly_arn`
  - Apply the layer from your local machine. This is done from local as we have the sourced admin level keys and we do not want to have these stored on aws/the internet
    - both of these commands will be run using aws-vault using your relevant shared account profile
    - run `aws-vault exec shared-profile -- terraform init -upgrade` to pull in the new modules
    - run `aws-vault exec shared-profile -- terraform apply` to apply the changes, before approving the apply, ensure that the plan is only creating your new environment

### Adding the new enviromnent to the infrastructure repository
Switch to the `bichard7-next-infrastructure` repository and do the following.

  - Add a new profile for the environment to the `aws_config.cfg` in the docs subdirectory. This is for anyone to be able to assume a role into the new enviroment from their local aws-vault
  - For each of the following layers add the account id and alias to `variables.tf` in the `accounts` variable:-
    - audit_logging
    - base_infra
    - cloudwatch_alarms
    - cloudwatch_logging
    - dev_security_group_rules
    - monitoring
    - reporting
    - security_groups
    - smtp_service
    - stack_data_storage
    - stack_infrastructure
    - user_service
    - vpc_peering
  - If the account is part of the path to live environment, ensure that you add the account id to the `path_to_live_accounts` variable in `variables.tf` on all layers.
  - If the account connects to the PNC , ensure that you add the account to both the `accounts` and `path_to_live_accounts` variables in the following layers
    - pnc_integration
  - Ensure that you add a valid new cidr block to the `cidr_blocks` variable in the `base_infra` layer.
  - If the account has a Codebuild managed environment, ensure that you give it a completely unique cidr block along with the environment name in the `managed_cidr_blocks` variable in `base_infra`. This is so that codebuild can correctly route to the environment with VPC peering.
  - Edit the `provision_infrastructure.py` file under the `./scripts` directory
    - If this is a sandbox account, add the alias into the  `_non_prod_accounts` list
    - If this is a pathtolive account, add the alias into the  `_path_to_live_accounts` list
    - If this is a PAAS account, add the alias into the  `_paas_accounts` list

### Ensuring the environment is ready for automation

If the account is provisioned and maintained by codebuild you will need to create and upload vpn certificates for the environment prior to running the first automated deployment.
These are consumed in the build script in the `prepare_vpn_certs.sh` script and are injected from SSM by codebuild.

These commands will be run in this repository

  - We need to generate the certificate files, this is done by running the `make generate-certificates` script with the following arguments
    - WORKSPACE="myworkspace"
    - ENVIRONMENT="pathtolive"
  - This will create the certificates in either the `sandbox` or `pathtolive` infra directories under the path of `VpnCerts/WORKSPACE`
  - We then need to upload the certificates to ssm
    - run `WORKSPACE="myworkspace" ENVIRONMENT="pathtolive" aws-vault exec shared-account-profile -- make upload-certificates`
  - This will upload the certificates to ssm so that codebuild will be able to consume then when it is configured and run.

### Removing a shared environment.
 - Run aws-nuke on the child environment to turn off any running resources do this as an ad-hoc job
 - Remove the file that contains the child environment configuration from the infra directory as well as related outputs. Do not remove the provider as this will cause terraform to be unable to manage the state.
 - Run `aws-vault exec shared-profile -- terraform init -upgrade` to pull in the new modules
 - Run `aws-vault exec shared-profile -- terraform apply` to apply the changes, before approving the apply, ensure that the plan is only creating your new environment
 - Once the apply has completed and the child environment resources have been removed, you can delete the provider block.
