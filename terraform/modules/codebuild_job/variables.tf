variable "tags" {
  description = "A map of resource tags"
  type        = map(string)
}

variable "name" {
  description = "Our resource name"
  type        = string
}

variable "codepipeline_s3_bucket" {
  description = "Our shared bucket for codepipeline"
  type        = string
}

variable "git_ref" {
  description = "The git reference we want to use"
  type        = string
  default     = "main"
}

variable "sns_notification_arn" {
  description = "The arn of our build queue"
  type        = string
}

variable "sns_kms_key_arn" {
  description = "The arn for our encryption key for sns"
  type        = string
}

variable "is_cd" {
  default     = false
  type        = bool
  description = "Is this a CI/CD environment"
}

variable "deployment_name" {
  description = "The deployment-name for CD usage, required only if is_cd is true"
  type        = string
  default     = ""
}

variable "deploy_account_name" {
  description = "The deployment account name for CD usage, required only if is_cd is true"
  type        = string
  default     = ""
}

variable "allowed_resource_arns" {
  description = "A list of resource arns that we are allowed access too"
  type        = list(string)
  default     = []
}

variable "repository_name" {
  description = "The name of our primary repository to clone from ie bichard7-next"
  type        = string
}

variable "environment_variables" {
  # Example of an env VAR
  //  {
  //    name  = "NAME"
  //    value = "VALUE"
  //    type  = "PARAMETER_STORE/SECRETS_MANAGER/PLAINTEXT optional defaults to PLAINTEXT"
  //  }
  description = "A list of maps of our environment variables type can be unset"
  type        = list(map(string))
  default     = []
}

variable "build_environments" {
  description = "A list of maps of our build environments"
  type        = list(map(string))
  default = [
    {
      compute_type    = "BUILD_GENERAL1_SMALL"
      image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
      type            = "LINUX_CONTAINER"
      privileged_mode = true
    }
  ]
}

variable "codebuild_secondary_sources" {
  description = "A list of secondary source maps"
  default     = {}
  type        = any
}

variable "build_description" {
  description = "The description of our build job"
  type        = string
}

variable "build_timeout" {
  description = "How long, in minutes, before we terminate our build as non responsive"
  type        = number
  default     = 180
}

variable "event_type_ids" {
  description = "A list of event types we want to notify on"
  type        = list(string)
  default = [
    "codebuild-project-build-state-failed"
  ]
}

variable "buildspec_file" {
  description = "The name and path of our buildspec file"
  default     = "buildspec.yml"
  type        = string
}

variable "vpc_config" {
  description = "The config for our codebuild vpc"
  type        = any
  default     = []
}

variable "report_build_status" {
  description = "Do we want to report the build status upstream"
  type        = bool
  default     = false
}

# tfsec:ignore:general-secrets-sensitive-in-variable
# tfsec:ignore:general-secrets-no-plaintext-exposure
variable "aws_access_key_id_ssm_path" {
  description = "Path to our ssm access key"
  default     = "/ci/user/access_key_id"
}

# tfsec:ignore:general-secrets-sensitive-in-variable
# tfsec:ignore:general-secrets-no-plaintext-exposure
variable "aws_secret_access_key_ssm_path" {
  description = "Path to access to our smm secret access key"
  default     = "/ci/user/secret_access_key"
}
