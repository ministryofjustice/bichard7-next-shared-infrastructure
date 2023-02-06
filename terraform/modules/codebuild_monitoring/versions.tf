terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.75.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.3.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "1.19.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "= 2.2.0"
    }
  }
  required_version = ">= 0.13"
}
