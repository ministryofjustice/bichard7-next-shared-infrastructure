data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "this" {}

data "aws_security_group" "cluster_sg" {
  name = var.security_group_name
}

data "aws_ecs_cluster" "cluster" {
  count        = var.create_cluster == false ? 1 : 0
  cluster_name = var.cluster_name
}

data "aws_iam_role" "admin_role" {
  name = "Bichard7-Administrator-Access"
}
