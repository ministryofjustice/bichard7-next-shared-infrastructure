## Shared Account Parent Infrastructure

To bootstrap a set of accounts to allow us to assume roles etc into, run the following steps

  - In the case of production and preprod, you will need an account on the vendors PAAS
  - run `aws-vault exec your-shared-parent-credentials -- make shared-account-(pathtolive/sandbox)-bootstrap`
  - run `aws-vault exec your-shared-parent-credentials -- make shared-account-(pathtolive/sandbox)-infra`
  - run `aws-vault exec your-shared-parent-credentials -- make shared-account-(pathtolive/sandbox)-infra-ci`
