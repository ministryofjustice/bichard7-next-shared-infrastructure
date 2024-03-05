terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
  required_version = ">= 0.13"
}
