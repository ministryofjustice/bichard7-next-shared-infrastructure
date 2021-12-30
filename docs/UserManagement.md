## Shared Accounts User Management

### Adding users

To add a user to the shared accounts, firstly create a ssm entry to store their email on the parent account. This needs to exist under
the path `/users/`. Convention is `firstname_lastname` for the parameter name and the contents is their email address.
This is stored as a SecureString using the default KMS key

Once the user's ssm parameter has been created, they can be added to the relevant file, there are 2 resources and one data block per user.
With naming these we have used the `firstname_lastname` convention with all of the relevant objects.

```terraform
data "aws_ssm_parameter" "firstname_lastname" {
  name = "/users/firstname_lastname"
}

resource "aws_iam_user" "firstname_lastname" {
  name = data.aws_ssm_parameter.firstname_lastname.value

  tags = var.tags
}

resource "aws_iam_user_group_membership" "firstname_lastname" {
  groups = [
    aws_iam_group.xxx.name,
    aws_iam_group.mfa_group.name
  ]
  user = aws_iam_user.firstname_lastname.name
}
```

### Removing Users

To remove the users, simply delete the blocks and then run the terraform. Once applied you can delete the ssm parameter.
