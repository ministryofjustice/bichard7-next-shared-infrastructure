#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "codebuild_flow_logs_bucket" {
  bucket = "${var.name}-codebuild-flow-logs"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "codebuild_flow_logs_bucket_acl" {
  bucket = aws_s3_bucket.codebuild_flow_logs_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_logging" "codebuild_flow_logs_bucket_logging" {
  bucket        = aws_s3_bucket.codebuild_flow_logs_bucket.id
  target_bucket = var.aws_logs_bucket
  target_prefix = "codebuild-flow-logs/"
}

resource "aws_s3_bucket_versioning" "codebuild_flow_logs_bucket_versioning" {
  bucket = aws_s3_bucket.codebuild_flow_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# trivy:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild_flow_logs_bucket_encryption" {
  bucket = aws_s3_bucket.codebuild_flow_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "codebuild_flow_logs_bucket" {
  bucket = aws_s3_bucket.codebuild_flow_logs_bucket.bucket
  policy = templatefile("${path.module}/policies/codebuild_flow_logs_bucket.json.tpl", {
    codebuild_flow_logs_bucket_arn = aws_s3_bucket.codebuild_flow_logs_bucket.arn
  })
}

resource "aws_s3_bucket_public_access_block" "codebuild_flow_logs_bucket" {
  bucket = aws_s3_bucket.codebuild_flow_logs_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "${var.name}-codebuild-vpc"
  cidr = local.cidr_block

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_vpn_gateway      = false
  create_igw              = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  enable_flow_log           = true
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = aws_s3_bucket.codebuild_flow_logs_bucket.arn
  vpc_flow_log_tags = merge(
    var.tags,
    { name = "${var.name}-codebuild-flow-logs" }
  )

  manage_default_security_group  = true
  default_security_group_egress  = []
  default_security_group_ingress = []

  tags = var.tags
}

resource "aws_security_group" "codebuild_vpc_sg" {
  description = "Codebuild SG for our VPC"
  name_prefix = var.name

  vpc_id = module.vpc.vpc_id
  tags = merge(
    var.tags,
    {
      name = "${var.name}-codebuild-vpc"
    }
  )
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_all_github_ssl" {
  description = "Allow outbound ssl traffic"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_all_github_ssh" {
  description = "Allow outbound ssh traffic"

  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_all_github_http" {
  description = "Allow outbound http traffic"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_all_github_git" {
  description = "Allow outbound git traffic"

  from_port = 9418
  to_port   = 9418
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_outbound_gpg_server_traffic" {
  description = "Allow outbound gpg server traffic"

  from_port = 11371
  to_port   = 11371
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_github_http_ingress" {
  description = "Allow http traffic from github to ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  type      = "ingress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  # Hook cidrs defined in https://api.github.com/meta
  cidr_blocks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20"
  ]
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_github_ssl_ingress" {
  description = "Allow outbound ssl traffic"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "ingress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  # Hook cidrs defined in https://api.github.com/meta
  cidr_blocks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
  ]
}

resource "aws_vpc_endpoint" "codepipeline_vpc_endpoint" {
  service_name      = "com.amazonaws.${data.aws_region.current.name}.codepipeline"
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.codebuild_vpc_sg.id
  ]

  tags = var.tags
}

resource "aws_security_group_rule" "vpc_to_cb_vpce_egress" {
  description = "Allow VPC to talk to vpce endpoints"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
}

resource "aws_security_group_rule" "vpce_to_cb_vpc_ingress" {
  description = "Allow vpce to talk to vpc"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "ingress"

  security_group_id = aws_security_group.codebuild_vpc_sg.id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
}
