data "template_file" "codebuild_scanners_dashboard" {
  template = file("${path.module}/templates/codebuild_scanners_dashboard.json")

  vars = {
    region               = data.aws_region.current_region.name
    trivy_project        = module.common_build_jobs.trivy_scan_containers_name
    scoutsuite_shared    = module.scoutsuite_scan_shared.pipeline_name
    scoutsuite_sandbox_a = module.scoutsuite_scan_sandbox_a.pipeline_name
    scoutsuite_sandbox_b = module.scoutsuite_scan_sandbox_b.pipeline_name
    scoutsuite_sandbox_c = module.scoutsuite_scan_sandbox_c.pipeline_name

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
