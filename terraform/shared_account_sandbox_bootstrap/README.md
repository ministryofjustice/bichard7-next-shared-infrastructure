# Shared Account Sandbox Bootstrap

Configures a shared bucket for state and dynamodb table for terraform state management.
The state is not automatically persisted to s3, but can be retrieved from the key `bootstrap/terraform.tfstate`. Copy this using aws s3 cp prior to running terraform against the remote and copy it back once done

*NB!*
If we do not pull the state and persist it to the remote we will have to re-import all of the resources
from scratch.

To update:

```shell
$ aws-vault exec bichard7-sandbox-shared -- aws s3 cp s3://jse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate/bootstrap/terraform.tfstate terraform.tfstate
$ aws-vault exec bichard7-sandbox-shared -- terraform init -upgrade
$ aws-vault exec bichard7-sandbox-shared -- terraform apply
$ aws-vault exec bichard7-sandbox-shared -- aws s3 cp terraform.tfstate s3://cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate/bootstrap/terraform.tfstate
```
