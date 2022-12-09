# Shared Account Sandbox Infrastructure

Configures child/parent relationships as well as roles across our shared accounts

Prior to running this ensure that you have the following variables exported

### Delegated hosted zones

MoJ have provided us with a top level delegated hosted zone, this is created in
this layer and the shared delegated zone for dev environments is created from this.
Furthermore, we allow the pathtolive account access to a role, which allows it to update dns
entries as it has a hosted zone that is delegated from the base MoJ zone.

The name servers for the delegated zone, must exist as a NS entry in the parent zone for it
to be searchable via dns.

```shell
export TF_VAR_sandbox_a_access_key=""
export TF_VAR_sandbox_a_secret_key=""
export TF_VAR_sandbox_b_access_key=""
export TF_VAR_sandbox_b_secret_key=""
export TF_VAR_sandbox_c_access_key=""
export TF_VAR_sandbox_c_secret_key=""
```
