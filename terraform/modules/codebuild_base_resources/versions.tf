terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
  }
  required_version = ">= 0.13"
}
