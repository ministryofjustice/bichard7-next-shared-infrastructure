# Codebuild Webhook

Module that allows codebuild to create a github webhook

Terraform is non deterministic with these webhooks and as such can't see if they no longer exist or are invalid in github.

To refresh them we need to do the following:-

- Log into github, under settings/webhooks in the repository delete the aws codebuild webhooks
- in the relevant shared infra ci layer run the following
- ```shell
     $ aws-vault exec bichard7-<shared account suffix> # This will create a subshell with your aws vault credentials
     $ terraform init --upgrade
     $ terraform state list | grep aws_codebuild_webhook # This will give us a list of webhook resources
     # For each item in the list above run the following
     $ terraform taint path.to.aws_codebuild_webhook
     $ exit # to return to your normal shell
  ```
  Once all of the resources have been tainted, run the apply-ci-layer job in codebuild
