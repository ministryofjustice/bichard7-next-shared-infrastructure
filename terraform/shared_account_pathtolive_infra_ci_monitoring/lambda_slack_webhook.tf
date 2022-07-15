module "lambda_slack_webhook" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/lambda_slack_webhook"

  name = "${terraform.workspace}-bichard-7"

  is_path_to_live = true

  tags = module.label.tags
}
