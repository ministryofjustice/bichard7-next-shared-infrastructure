locals {
  remote_bucket_name = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
  public_dns_name    = lower("cd.${data.terraform_remote_state.shared_infra.outputs.delegated_hosted_zone.name}")
  environment        = "pathtolive"
}
