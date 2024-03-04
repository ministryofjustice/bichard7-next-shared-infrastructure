locals {
  shared_docker_image_policy = templatefile("${path.module}/templates/shared_image_policy.json.tpl", {
    allowed_account_arns = jsonencode(sort(formatlist("arn:aws:iam::%s:root", var.child_account_ids)))
  })
}