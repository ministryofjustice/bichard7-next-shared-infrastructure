#!/usr/bin/env bash

readonly POLICY_ARN="arn:aws:iam::aws:policy/AdministratorAccess"
readonly GROUP_NAME="CIAccess"
### Use the aws cli to elevate the CI/CD user to admin by attaching a policy to the group
aws iam attach-group-policy --group-name ${GROUP_NAME} --policy-arn ${POLICY_ARN}
echo "Waiting 30 seconds for IAM permissions to apply"
sleep 30
cd shared_terraform/shared_account_${ENVIRONMENT}_infra_ci
terraform init
terraform apply -auto-approve

### Remove policy attachment
aws iam detach-group-policy --group-name ${GROUP_NAME} --policy-arn ${POLICY_ARN}
