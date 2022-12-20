# Shared Account Parent

Module to set up roles and shared resources on an AWS parent account

### Pre-requisites

The CI username needs to be created as a ssm parameter on the parent account under the path `/users/system/ci`

If you want to create a user for AWS Nuke, the variable create_nuke_user needs to be set to true and we need a ssm parameter under the path
`/users/system/aws_nuke`
