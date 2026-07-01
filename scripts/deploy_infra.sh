#!/bin/bash

set -e

./scripts/set-terraform-access-keys.sh ./scripts/shared_account_terraform.py $ENVIRONMENT infra
