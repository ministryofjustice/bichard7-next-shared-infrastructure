provider "tls" {
}

provider "null" {
}

provider "template" {
}

provider "aws" {
  region = var.region
  alias  = "sandbox_shared"
}

provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.sandbox_a_access_key
  secret_key = var.sandbox_a_secret_key
  alias      = "sandbox_a"
}

provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.sandbox_b_access_key
  secret_key = var.sandbox_b_secret_key
  alias      = "sandbox_b"
}

provider "aws" {
  region     = data.aws_region.current_region.name
  access_key = var.sandbox_c_access_key
  secret_key = var.sandbox_c_secret_key
  alias      = "sandbox_c"
}
