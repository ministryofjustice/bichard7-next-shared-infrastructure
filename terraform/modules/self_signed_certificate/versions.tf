terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.parent,
      ]
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 3.1.0"
    }
  }
  required_version = ">= 0.13"
}
