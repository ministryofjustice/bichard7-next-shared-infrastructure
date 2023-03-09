#!/bin/bash

set -e

ACCOUNTS_SSM_KEY=/cjse/bichard7/accounts/administrator-role

if [[ "$CI_USER" == "true" ]]; then
  ACCOUNTS_SSM_KEY=/cjse/bichard7/accounts/ci-admin-role
fi

ACCOUNTS=$(aws ssm get-parameter --name $ACCOUNTS_SSM_KEY --query "Parameter.Value" --output text)
SANDBOX_A_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".sandbox_a")
SANDBOX_B_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".sandbox_b")
SANDBOX_C_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".sandbox_c")

SANDBOX_A=$(aws sts assume-role --role-arn $SANDBOX_A_ADMIN_ROLE --role-session-name sandbox-a)
export TF_VAR_sandbox_a_access_key=$(echo "${SANDBOX_A}" | jq -r ".Credentials.AccessKeyId")
export TF_VAR_sandbox_a_secret_key=$(echo "${SANDBOX_A}" | jq -r ".Credentials.SecretAccessKey")
export TF_VAR_sandbox_a_session_token=$(echo "${SANDBOX_A}" | jq -r ".Credentials.SessionToken")

SANDBOX_B=$(aws sts assume-role --role-arn $SANDBOX_B_ADMIN_ROLE --role-session-name sandbox-b)
export TF_VAR_sandbox_b_access_key=$(echo "${SANDBOX_B}" | jq -r ".Credentials.AccessKeyId")
export TF_VAR_sandbox_b_secret_key=$(echo "${SANDBOX_B}" | jq -r ".Credentials.SecretAccessKey")
export TF_VAR_sandbox_b_session_token=$(echo "${SANDBOX_B}" | jq -r ".Credentials.SessionToken")

SANDBOX_C=$(aws sts assume-role --role-arn $SANDBOX_C_ADMIN_ROLE --role-session-name sandbox-c)
export TF_VAR_sandbox_c_access_key=$(echo "${SANDBOX_C}" | jq -r ".Credentials.AccessKeyId")
export TF_VAR_sandbox_c_secret_key=$(echo "${SANDBOX_C}" | jq -r ".Credentials.SecretAccessKey")
export TF_VAR_sandbox_c_session_token=$(echo "${SANDBOX_C}" | jq -r ".Credentials.SessionToken")

./scripts/shared_account_terraform.py sandbox infra
