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
  }
  required_version = ">= 0.13"
}
