data "aws_region" "current_region" {
}

data "aws_caller_identity" "current" {
}

data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket         = local.remote_bucket_name
    dynamodb_table = "${local.remote_bucket_name}-lock"
    key            = "tfstatefile"
    region         = "eu-west-2"
  }
}

data "terraform_remote_state" "shared_infra_ci" {
  backend = "s3"
  config = {
    bucket         = local.remote_bucket_name
    dynamodb_table = "${local.remote_bucket_name}-lock"
    key            = "ci/tfstatefile"
    region         = "eu-west-2"
  }
}

data "archive_file" "query_num_ecr_images" {
  output_path = "/tmp/query_long_running_fns.zip"
  type        = "zip"

  source {
    content = templatefile("${path.module}/source/query_num_ecr_images.py.tpl", {
      region     = data.aws_region.current_region.name
      account_id = data.aws_caller_identity.current.account_id
      env        = terraform.workspace
    })
    filename = "query_num_ecr_images.py"
  }
}

// data sns topic for slack webhook
