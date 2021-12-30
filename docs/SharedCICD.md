## Setting up the Shared CI/CD environments

The shared CI/CD env is on its own terraform layer. We have separate ones corresponding to
`pathtolive` and `sandbox`

Currently, both environments have a job to build packer amis on a weekly schedule· As modules are opinionated, we have created
a set of modules, each representing a CI/CD task as well as some generic helpers.

### Helpers

 - codebuild_base: This module creates a logging bucket, a sns notifications queue as well as a linked lambda that parses, the message and posts this to slack.
 - codebuild_docker_resources: We store our own copy of public docker images in this module due to docker hub rate limiting and security concerns

### Codebuild Modules

 - codebuild_ami_builder: Weekly schedule to build our required amis
 - codebuild_deploy_environment: Project to build/destroy and environment via terraform

### Adding a target to the CI/CD pipeline

 - Add your module to terraform_modules/code(build/pipeline)_<name>
 - Consume your module in shared_terraform/shared_account_(sandbox/pathtolive)_infra_ci
 - run `aws-vault exec <your-shared-profile> -- make shared-account-(sandbox/pathtolive)-infra-ci`

### Removing a target to the CI/CD pipeline

  - Remove your module from shared_terraform/shared_account_(sandbox/pathtolive)_infra_ci
  - run `aws-vault exec <your-shared-profile> -- make shared-account-(sandbox/pathtolive)-infra-ci`
