provider "tls" {
}

provider "null" {
}

provider "aws" {
  region = var.region
  alias  = "shared"
}

# Credentials match bichard7-test-next account
provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.integration_next_access_key
  secret_key = var.integration_next_secret_key
  token      = var.integration_next_session_token
  alias      = "integration_next"
}

# Credentials match bichard7-test-current account
provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.integration_baseline_access_key
  secret_key = var.integration_baseline_secret_key
  token      = var.integration_baseline_session_token
  alias      = "integration_baseline"
}

provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.preprod_access_key
  secret_key = var.preprod_secret_key
  token      = var.preprod_session_token
  alias      = "preprod"
}

provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.preprod_access_key
  secret_key = var.preprod_secret_key
  token      = var.preprod_session_token
  alias      = "qsolution"
}


provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.production_access_key
  secret_key = var.production_secret_key
  token      = var.production_session_token
  alias      = "production"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::258361008057:role/AllowPathToLiveAssumeRole"
  }

  alias = "sandbox"
}
