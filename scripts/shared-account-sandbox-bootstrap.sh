#!/bin/bash

if [ -n "$WORKSPACE" ]
then
  echo "WORKSPACE should not be set"
  exit 1
fi

./scripts/shared_account_terraform.py sandbox bootstrap
