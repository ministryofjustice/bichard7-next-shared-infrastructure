locals {
  access_template                         = (length(var.denied_user_arns) > 0) ? "allow_assume_role_with_deny.json.tpl" : "allow_assume_role.json.tpl"
  no_mfa_access_template                  = (length(var.denied_user_arns) > 0) ? "allow_assume_role_with_deny_no_mfa.json.tpl" : "allow_assume_role_no_mfa.json.tpl"
  no_mfa_multi_user_roles_access_template = (length(var.denied_user_arns) > 0) ? "allow_assume_role_with_deny_no_mfa_multi_user_roles.json.tpl" : "allow_assume_role_no_mfa_multi_user_roles.json.tpl"
}
