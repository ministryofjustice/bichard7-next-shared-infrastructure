terraform {
  backend "s3" {
    bucket         = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
    key            = "ci/tfstatefile"
    dynamodb_table = "cjse-bichard7-default-pathtolive-bootstrap-tfstate-lock"
  }
}
