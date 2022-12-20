terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.75.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 3.1.0"
    }
  }
  required_version = ">= 0.13"
}
