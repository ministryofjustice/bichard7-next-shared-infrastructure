data "aws_region" "current_region" {
}

data "aws_caller_identity" "current" {
}

data "template_file" "shared_docker_image_policy" {
  template = file("${path.module}/templates/shared_image_policy.json.tpl")

  vars = {
    allowed_account_arns = jsonencode(sort(formatlist("arn:aws:iam::%s:root", var.child_account_ids)))
  }
}
