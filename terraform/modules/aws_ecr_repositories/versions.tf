terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.75.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 2.15.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "= 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.0.0"
    }
  }
  required_version = ">= 0.13"
}
