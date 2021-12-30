provider "aws" {
}

provider "aws" {
  assume_role {
    role_arn = local.sandbox_a_arn
  }
  alias = "sandbox_a"
}

provider "aws" {
  assume_role {
    role_arn = local.sandbox_b_arn
  }
  alias = "sandbox_b"
}

provider "aws" {
  assume_role {
    role_arn = local.sandbox_c_arn
  }
  alias = "sandbox_c"
}
