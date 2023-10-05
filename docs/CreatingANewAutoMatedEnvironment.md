## Automated environments

To create a new automated environment
 - run `ENVIRONMENT=<ENV> WORKSPACE=<WORKSPACE> make generate-certificates` where env is either pathtolive or sandbox and workspace is the name of the environment
 - run `ENVIRONMENT=<ENV> WORKSPACE=<WORKSPACE> aws-vault exec <SHARED_PARENT_ACCOUNT_NAME> -- make upload-certificates` where env is either pathtolive or sandbox and workspace is the name of the environment
 - Create the environment create/destroy and optional triggers in the relevant account ci section
 - Apply the layer
