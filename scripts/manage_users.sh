#!/usr/bin/env bash

set -e

pip3 install virtualenv
python3 -m venv .venv
source .venv/bin/activate
pip3 install ansible==5.2.0 boto3==1.20.45
ansible-galaxy collection install community.aws
cd ansible
ENVIRONMENT=${WORKSPACE:-sandbox} ansible-playbook playbook.yml
cd ../
deactivate
