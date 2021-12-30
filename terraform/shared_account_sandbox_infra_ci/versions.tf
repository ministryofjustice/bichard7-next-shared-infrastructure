terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.10"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0.0"
    }
  }
  required_version = ">= 0.13"
}
