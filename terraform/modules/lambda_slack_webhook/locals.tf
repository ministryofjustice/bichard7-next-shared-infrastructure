locals {
  is_production = (terraform.workspace == "production" || var.is_path_to_live) ? true : false
}
