terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.72.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.0.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "1.19.0"
    }
  }
  required_version = ">= 0.13"
}
