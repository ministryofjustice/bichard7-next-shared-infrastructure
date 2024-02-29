terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.parent,
      ]
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.3.0"
    }
  }
  required_version = ">= 0.13"
}
