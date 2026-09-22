terraform {
  backend "s3" {
    bucket       = "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
    key          = "ci/tfstatefile"
    use_lockfile = true
  }
}
