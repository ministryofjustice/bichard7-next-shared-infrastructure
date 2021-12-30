#!/bin/bash

if [ -n "$WORKSPACE" ]
then
  echo "WORKSPACE should not be set"
  exit 1
fi

cd shared_account_pathtolive_bootstrap
terraform init

if [ "$AUTO_APPROVE" = "true" ]
then
  terraform apply -auto-approve
else
  terraform apply
fi
