#!/bin/bash

set -e

ACCOUNTS_SSM_KEY=/cjse/bichard7/accounts/administrator-role

if [[ "$CI_USER" == "true" ]]; then
  ACCOUNTS_SSM_KEY=/cjse/bichard7/accounts/ci-admin-role
fi

ACCOUNTS=$(aws ssm get-parameter --name $ACCOUNTS_SSM_KEY --query "Parameter.Value" --output text)

if [[ "$ENVIRONMENT" == "sandbox" ]]; then
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

elif [[ "$ENVIRONMENT" == "pathtolive" ]]; then
  INTEGRATION_NEXT_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".integration_next")
  INTEGRATION_BASELINE_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".integration_baseline")
  PREPROD_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".q_solution")
  PRODUCTION_ADMIN_ROLE=$(echo $ACCOUNTS | jq -r ".production")

  INTEGRATION_NEXT=$(aws sts assume-role --role-arn $INTEGRATION_NEXT_ADMIN_ROLE --role-session-name integration-next)
  export TF_VAR_integration_next_access_key=$(echo "${INTEGRATION_NEXT}" | jq -r ".Credentials.AccessKeyId")
  export TF_VAR_integration_next_secret_key=$(echo "${INTEGRATION_NEXT}" | jq -r ".Credentials.SecretAccessKey")
  export TF_VAR_integration_next_session_token=$(echo "${INTEGRATION_NEXT}" | jq -r ".Credentials.SessionToken")

  INTEGRATION_BASELINE=$(aws sts assume-role --role-arn $INTEGRATION_BASELINE_ADMIN_ROLE --role-session-name integration-baseline)
  export TF_VAR_integration_baseline_access_key=$(echo "${INTEGRATION_BASELINE}" | jq -r ".Credentials.AccessKeyId")
  export TF_VAR_integration_baseline_secret_key=$(echo "${INTEGRATION_BASELINE}" | jq -r ".Credentials.SecretAccessKey")
  export TF_VAR_integration_baseline_session_token=$(echo "${INTEGRATION_BASELINE}" | jq -r ".Credentials.SessionToken")

  PREPROD=$(aws sts assume-role --role-arn $PREPROD_ADMIN_ROLE --role-session-name preprod)
  export TF_VAR_preprod_access_key=$(echo "${PREPROD}" | jq -r ".Credentials.AccessKeyId")
  export TF_VAR_preprod_secret_key=$(echo "${PREPROD}" | jq -r ".Credentials.SecretAccessKey")
  export TF_VAR_preprod_session_token=$(echo "${PREPROD}" | jq -r ".Credentials.SessionToken")

  PRODUCTION=$(aws sts assume-role --role-arn $PRODUCTION_ADMIN_ROLE --role-session-name production)
  export TF_VAR_production_access_key=$(echo "${PRODUCTION}" | jq -r ".Credentials.AccessKeyId")
  export TF_VAR_production_secret_key=$(echo "${PRODUCTION}" | jq -r ".Credentials.SecretAccessKey")
  export TF_VAR_production_session_token=$(echo "${PRODUCTION}" | jq -r ".Credentials.SessionToken")

else
  echo "Unknown environment"
  exit 1
fi

./scripts/shared_account_terraform.py $ENVIRONMENT infra "plan"
