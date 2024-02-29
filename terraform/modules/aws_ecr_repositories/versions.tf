terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.parent,
      ]
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 3.0.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "= 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.3.0"
    }
  }
  required_version = ">= 0.13"
}
