resource "aws_budgets_budget" "main" {
  count = length(var.budget_limit_amount) > 0 ? 1 : 0

  name         = "main-budget"
  budget_type  = "COST"
  limit_amount = var.budget_limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 90
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_notification_email_addresses
  }
}
