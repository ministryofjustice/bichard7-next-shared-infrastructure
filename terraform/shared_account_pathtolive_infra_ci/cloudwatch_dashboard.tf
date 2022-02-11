data "template_file" "codebuild_scanners_dashboard" {
  template = file("${path.module}/templates/codebuild_scanners_dashboard.json")

  vars = {
    region                   = data.aws_region.current_region.name
    trivy_project            = module.common_build_jobs.trivy_scan_containers_name
    scoutsuite_shared        = module.scoutsuite_scan_shared.pipeline_name
    integration_baseline     = module.scoutsuite_scan_integration_baseline.pipeline_name
    integration_next         = module.scoutsuite_scan_integration_next.pipeline_name
    owasp_application        = module.owasp_scan_e2e_test.pipeline_name
    owasp_audit_logging      = module.owasp_scan_e2e_test_audit_logging.pipeline_name
    owasp_user_service       = module.owasp_scan_e2e_test_user_service.pipeline_name
    remove_e2e_test_dev_sgs  = module.remove_dev_sg_from_e2e_test.pipeline_name
    remove_preprod_dev_sgs   = module.remove_dev_sg_from_prod.pipeline_name
    remove_prod_dev_sgs      = module.remove_dev_sg_from_preprod.pipeline_name
    remove_load_test_dev_sgs = module.remove_dev_sg_from_load_test.pipeline_name
  }
}

resource "aws_cloudwatch_dashboard" "codebuild_scanners_dashboard" {
  dashboard_name = "Codebuild_Scanners_Dashboard"

  dashboard_body = data.template_file.codebuild_scanners_dashboard.rendered
}

data "template_file" "codebuild_automation_dashboard" {
  template = file("${path.module}/templates/codebuild_automation_dashboard.json")

  vars = {
    region = data.aws_region.current_region.name
  }
}

resource "aws_cloudwatch_dashboard" "codebuild_automation_dashboard" {
  dashboard_name = "Codebuild_Automation_Dashboard"

  dashboard_body = data.template_file.codebuild_automation_dashboard.rendered
}
