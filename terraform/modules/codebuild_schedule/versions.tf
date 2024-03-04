terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.parent,
      ]
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
  }
  required_version = ">= 0.13"
}
