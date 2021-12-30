#!/bin/bash

set -e

mkdir -p ./terraform/base_infra/VpnCerts
echo ${CA_CERT}     | base64 -d > ./terraform/base_infra/VpnCerts/ca.crt
echo ${SERVER_CERT} | base64 -d > ./terraform/base_infra/VpnCerts/server.crt
echo ${SERVER_KEY}  | base64 -d > ./terraform/base_infra/VpnCerts/server.key
echo ${CLIENT_CERT} | base64 -d > ./terraform/base_infra/VpnCerts/client1.domain.tld.crt
echo ${CLIENT_KEY}  | base64 -d > ./terraform/base_infra/VpnCerts/client1.domain.tld.key
