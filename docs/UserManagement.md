## Shared Accounts User Management

### Adding users

To add a user to the shared accounts, firstly create a ssm entry to store their email on the parent account. This needs to exist under
the path `/users/`. Convention is `firstname_lastname` for the parameter name and the contents is their email address.
This is stored as a SecureString using the default KMS key.

Once the user's ssm parameter has been created, they can be added to the [ansible vars file](../ansible/vars/users.yml).
If they do not exist in SSM ansible will skip over them during the creation/deletion section of the code.

The dictionary construct is quite simple:-
```yaml
- users_enabled:
    - name: firstname_lastname
      type: xxx # One of admin or readonly which is used as a lookup, see the file for more
```

Once added, running the [manage-aws-users](../terraform/modules/shared_cd_common_jobs/manage_aws_users.tf) codebuild job will create or remove the users.

### Removing Users

Remove the user from the `users_enabled` dictionary and add them to the `removed_users` dictionary. Running the same codebuild job will remove them from aws
```yaml
- removed_users:
    - name: deleted_user
```

### Non SC Users

Some users do not have their SC yet, add their ssm parameter key to the list `non_sc_users` to ensure they have no access to
the production environment.

```yaml
- non_sc_users:
    - new_user_name
```
