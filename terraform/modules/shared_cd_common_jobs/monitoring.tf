module "build_openjdk_jre11_slim" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-openjdk-jre11-slim-docker"
  build_description = "Codebuild for Building OpenJDK11 JRE Slim Image"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Openjdk_Jre11_Slim/buildspec.yml"

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn
  vpc_config             = var.vpc_config_block

  environment_variables = [
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  tags = var.tags
}

module "build_prometheus_blackbox_exporter" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-prometheus-blackbox-exporter-docker"
  build_description = "Codebuild for Building Prometheus Blackbox Exporter Images"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Prometheus_BlackBox_Exporter/buildspec.yml"
  vpc_config        = var.vpc_config_block

  environment_variables = [
    {
      name  = "DOCKER_IMAGE_HASH"
      value = ""
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags
}

module "build_prometheus_cloudwatch_exporter" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-prometheus-cloudwatch-exporter-docker"
  build_description = "Codebuild for Building Prometheus Cloudwatch Exporter Images"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Prometheus_Cloudwatch_Exporter/buildspec.yml"
  vpc_config        = var.vpc_config_block

  environment_variables = [
    {
      name  = "DOCKER_IMAGE_HASH"
      value = ""
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags
}

module "build_prometheus_docker" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-prometheus-docker"
  build_description = "Codebuild for Building Prometheus Images"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Prometheus/buildspec.yml"
  vpc_config        = var.vpc_config_block

  environment_variables = [
    {
      name  = "DOCKER_IMAGE_HASH"
      value = ""
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags
}

module "build_grafana_ssl_docker" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-grafana-ssl-docker"
  build_description = "Codebuild for Building Customised Grafana Images"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Grafana/buildspec.yml"
  vpc_config        = var.vpc_config_block

  environment_variables = [
    {
      name  = "DOCKER_IMAGE_HASH"
      value = ""
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags
}

module "build_grafana_ssl_docker_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_grafana_ssl_docker.pipeline_arn
  name            = module.build_grafana_ssl_docker.pipeline_name
  cron_expression = "cron(0 5 ? * 1 *)"
  tags            = var.tags
}

module "build_logstash_docker" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-logstash-docker"
  build_description = "Codebuild for Building Customised Logstash Images"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Logstash/buildspec.yml"
  vpc_config        = var.vpc_config_block

  environment_variables = [
    {
      name  = "DOCKER_IMAGE_HASH"
      value = ""
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags
}

module "build_logstash_docker_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_logstash_docker.pipeline_arn
  name            = module.build_logstash_docker.pipeline_name
  cron_expression = "cron(0 5 ? * 1 *)"
  tags            = var.tags
}

module "build_grafana_codebuild_ssl_docker" {
  source = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_job"

  name              = "build-grafana-codebuild-ssl-docker"
  build_description = "Codebuild for Building Customised Grafana Codebuild Images"
  repository_name   = "bichard7-next-infrastructure-docker-images"
  buildspec_file    = "./Grafana_Codebuild/buildspec.yml"
  vpc_config        = var.vpc_config_block

  environment_variables = [
    {
      name  = "DOCKER_IMAGE_HASH"
      value = ""
    },
    {
      name  = "ARTIFACT_BUCKET"
      value = var.codebuild_s3_bucket
    }
  ]

  codepipeline_s3_bucket = var.codebuild_s3_bucket
  sns_notification_arn   = var.sns_notifications_arn
  sns_kms_key_arn        = var.notifications_kms_key_arn

  tags = var.tags
}

module "build_grafana_codebuild_ssl_docker_schedule" {
  source          = "github.com/ministryofjustice/bichard7-next-infrastructure-modules.git//modules/codebuild_schedule"
  codebuild_arn   = module.build_grafana_codebuild_ssl_docker.pipeline_arn
  name            = module.build_grafana_codebuild_ssl_docker.pipeline_name
  cron_expression = "cron(0 5 ? * 1 *)"
  tags            = var.tags
}
