terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.58.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
  required_version = ">= 0.13"
}
