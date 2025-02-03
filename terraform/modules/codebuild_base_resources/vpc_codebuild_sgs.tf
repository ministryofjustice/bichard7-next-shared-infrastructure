resource "aws_security_group" "environment_codebuild_vpc_sgs" {
  for_each = var.codebuild_sg_environment_names

  description = "${each.value} Codebuild jobs SG for our VPC"
  name_prefix = "${var.name}-${each.value}"

  vpc_id = module.vpc.vpc_id
  tags = merge(
    var.tags,
    {
      name = "${var.name}-${each.value}-codebuild-vpc"
    }
  )
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "codebuild_egress_to_all_github_ssl" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow outbound ssl traffic"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "egress"

  security_group_id = each.value.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "codebuild_egress_to_all_github_ssh" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow outbound ssh traffic"

  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  type      = "egress"

  security_group_id = each.value.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "codebuild_egress_to_all_github_http" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow outbound http traffic"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  type      = "egress"

  security_group_id = each.value.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "codebuild_egress_to_all_github_git" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow outbound git traffic"

  from_port = 9418
  to_port   = 9418
  protocol  = "tcp"
  type      = "egress"

  security_group_id = each.value.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "codebuild_egress_to_gpg_server" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow outbound gpg server traffic"

  from_port = 11371
  to_port   = 11371
  protocol  = "tcp"
  type      = "egress"

  security_group_id = each.value.id
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "codebuild_ingress_from_github_http" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow http traffic from github to ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  type      = "ingress"

  security_group_id = each.value.id
  # Hook cidrs defined in https://api.github.com/meta
  cidr_blocks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20"
  ]
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "codebuild_ingress_from_github_ssl" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  description = "Allow outbound ssl traffic"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "ingress"

  security_group_id = each.value.id
  # Hook cidrs defined in https://api.github.com/meta
  cidr_blocks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
  ]
}

resource "aws_vpc_endpoint_security_group_association" "codepipeline_vpce_codebuild_sgs" {
  for_each = aws_security_group.environment_codebuild_vpc_sgs

  vpc_endpoint_id   = resource.aws_vpc_endpoint.codepipeline_vpc_endpoint.id
  security_group_id = each.value.id
}
