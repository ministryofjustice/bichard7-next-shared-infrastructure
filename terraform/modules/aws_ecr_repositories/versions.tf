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
      version = "3.0.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
  }
  required_version = ">= 0.13"
}
