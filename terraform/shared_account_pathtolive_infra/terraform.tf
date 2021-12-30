terraform {
  backend "s3" {
    bucket         = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
    key            = "tfstatefile"
    dynamodb_table = "cjse-bichard7-default-pathtolive-bootstrap-tfstate-lock"
  }
}
