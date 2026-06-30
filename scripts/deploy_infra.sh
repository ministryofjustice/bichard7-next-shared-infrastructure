#!/bin/bash

set -e

./scripts/set_infra_credentials.sh
./scripts/shared_account_terraform.py $ENVIRONMENT infra
