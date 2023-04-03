# Bichard7 Next Shared Infrastructure

A collection of terraform layers for shared infrastructure used to provision our environments.

## Getting started

You will need an AWS account api credentials (secret and id)

- install the aws cli. We're using brew on both OSX and Linux for simplicity. Installation instructions for brew can be found [here](https://brew.sh/)

```bash
brew install --user awscli
```

### Install tfenv

```bash
brew install tfenv
tfenv install 1.4.4
tfenv use 1.4.4
```

### Install required tooling for terraform checks

```shell
brew install tfsec terraform-docs tflint yamllint jq pre-commit
```

### Install the pre-commit hooks

```shell
pre-commit install
```
## Other documentation
- [Deploying Shared Parent Infrastructure](./docs/SharedParentInfra.md)
- [User Management](./docs/UserManagement.md)
- [Shared Account CI/CD](./docs/SharedCICD.md)

## Shared Terraform infrastructure

We have 2 shared environments configured. Sandbox and PathToLive. These accounts can be accessed via shared credentials. If you have a user account on the parent account of either
of these environments, you can see how to assume roles on either [the sandbox](terraform/shared_account_sandbox_infra/README.md) or [path to live](terraform/shared_account_pathtolive_infra/README.md) accounts.
The CI keys are stored in the 1password vault.

To deploy to the shared environments we need a few more environment variables.

    AWS_ACCOUNT_NAME - the name of the account we would like to deploy to ie sandbox_a or integration_next
    WORKSPACE - the name of your workspace you are going to be deploying to
    USER_TYPE (Optional) - If you are using your credentials it will attempt to assume the Bichard7-Administrator-Access role by default, if this is set to ci, then it will assume the relevant role.

As an example, to deploy as a ci user to sandbox_a, you will need to run something like the following:-

```shell
WORKSPACE=development AWS_ACCOUNT_NAME=sandbox_c USER_TYPE=ci aws-vault exec bichard7-sandbox-ci -- make shared-base-infra
```

This then in turn calls [a python](scripts/shared_account_terraform.py) script which will handle the create and destroy commands for each of the portions of infrastructure.
