terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.58.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
  }
  required_version = ">= 0.13"
}
