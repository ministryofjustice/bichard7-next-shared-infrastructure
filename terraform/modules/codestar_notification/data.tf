
data "template_file" "allow_kms_access" {
  template = file("${path.module}/policies/kms.json.tpl")

  vars = {
    sns_key_arn = var.sns_kms_key_arn
  }
}
