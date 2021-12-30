terraform {

  backend "s3" {
    bucket = "cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate"
    key    = "users/tfstatefile"
  }
}
