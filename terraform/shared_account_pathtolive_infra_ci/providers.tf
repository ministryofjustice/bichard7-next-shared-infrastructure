provider "aws" {}

provider "aws" {
  assume_role {
    role_arn = local.integration_baseline_arn
  }
  alias = "integration_baseline"
}

provider "aws" {
  assume_role {
    role_arn = local.integration_next_arn
  }
  alias = "integration_next"
}

provider "aws" {
  assume_role {
    role_arn = local.preprod_arn
  }
  alias = "qsolution"
}

provider "aws" {
  assume_role {
    role_arn = local.production_arn
  }

  alias = "production"
}
