.PHONY terraform-init:
terraform-init:
	./scripts/init_terraform.py terraform

# Generates VPN Certificates for a target managed environment for codebuild to consume
.PHONY: generate-certificates
generate-certificates:
	./scripts/generate_vpn_certificates.py

# Uploads VPN Certificates to the shared account for codebuild to consume
.PHONY: upload-certificates
upload-certificates:
	./scripts/upload_certificates_to_ssm.py

.PHONY: shared-account-sandbox-bootstrap
shared-account-sandbox-bootstrap:
	./scripts/shared-account-sandbox-bootstrap.sh

.PHONY: destroy-shared-account-sandbox-bootstrap
destroy-shared-account-sandbox-bootstrap:
	./scripts/destroy-shared-account-sandbox-bootstrap.sh

.PHONY: shared-account-sandbox-infra
shared-account-sandbox-infra:
	./scripts/shared_account_terraform.py sandbox infra

.PHONY: shared-account-sandbox-infra-ci
shared-account-sandbox-infra-ci:
	./scripts/shared_account_terraform.py sandbox infra_ci

.PHONY: shared-account-sandbox-infra-sonarqube
shared-account-sandbox-infra-ci-sonarqube:
	./scripts/shared_account_terraform.py sandbox infra_ci_sonarqube

.PHONY: shared-account-sandbox-users
shared-account-sandbox-users:
	./scripts/shared_account_terraform.py sandbox users

.PHONY: destroy-shared-account-sandbox-users
destroy-shared-account-sandbox-users:
	./scripts/shared_account_terraform.py sandbox users destroy

.PHONY: destroy-shared-account-sandbox-infra
destroy-shared-account-sandbox-infra:
	./scripts/shared_account_terraform.py sandbox infra destroy

.PHONY: destroy-shared-account-sandbox-infra-ci
destroy-shared-account-sandbox-infra-ci:
	./scripts/shared_account_terraform.py sandbox infra_ci destroy

.PHONY: destroy-shared-account-sandbox-infra-sonarqube
destroy-shared-account-sandbox-infra-ci-sonarqube:
	./scripts/shared_account_terraform.py sandbox infra_ci_sonarqube destroy

.PHONY: shared-account-pathtolive-bootstrap
shared-account-pathtolive-bootstrap:
	./scripts/shared-account-pathtolive-bootstrap.sh

.PHONY: destroy-shared-account-pathtolive-bootstrap
destroy-shared-account-pathtolive-bootstrap:
	./scripts/destroy-shared-account-pathtolive-bootstrap.sh

.PHONY: shared-account-pathtolive-infra
shared-account-pathtolive-infra:
	./scripts/shared_account_terraform.py pathtolive infra

.PHONY: destroy-shared-account-pathtolive-infra
destroy-shared-account-pathtolive-infra:
	./scripts/shared_account_terraform.py pathtolive infra destroy

.PHONY: shared-account-pathtolive-infra-ci
shared-account-pathtolive-infra-ci:
	./scripts/shared_account_terraform.py pathtolive infra_ci

.PHONY: destroy-shared-account-pathtolive-infra-ci
destroy-shared-account-pathtolive-infra-ci:
	./scripts/shared_account_terraform.py pathtolive infra destroy

.PHONY: shared-account-pathtolive-users
shared-account-pathtolive-users:
	./scripts/shared_account_terraform.py pathtolive users

.PHONY: destroy-shared-account-pathtolive-users
destroy-shared-account-pathtolive-users:
	./scripts/shared_account_terraform.py pathtolive users destroy
