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

.PHONY: shared-account-sandbox-infra-ci-sonarqube
shared-account-sandbox-infra-ci-sonarqube:
	./scripts/shared_account_terraform.py sandbox infra_ci_sonarqube

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
	./scripts/shared_account_terraform.py pathtolive infra_ci destroy

.PHONY: shared-account-pathtolive-infra-ci-monitoring
shared-account-pathtolive-infra-ci-monitoring:
	./scripts/shared_account_terraform.py pathtolive infra_ci_monitoring

.PHONY: destroy-shared-account-pathtolive-infra-ci-monitoring
destroy-shared-account-pathtolive-infra-ci-monitoring:
	./scripts/shared_account_terraform.py pathtolive infra_ci_monitoring destroy

.PHONY: terraform-clean-all
terraform-clean-all:
	bash -c "find . -name .terraform -type d | xargs rm -rf"
	bash -c "find . -name .terraform.lock.hcl -type f | xargs rm -rf"

.PHONY: terraform-validate
terraform-validate: terraform-init
	{ \
		set -e; \
  	for dir in ./terraform/*/; \
		do \
		 echo "Validating terraform in $${dir}"; \
		 cd "$${dir}"; \
		 AWS_REGION=placeholder-region-name terraform validate; \
		 cd ../../; \
	 done \
	}

.PHONY: manage-users
manage-users:
	./scripts/manage_users.sh
