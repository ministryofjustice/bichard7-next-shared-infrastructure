terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.75.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "= 2.1.0"
    }
  }
  required_version = ">= 0.13"
}
