resource "aws_security_group" "scanning_portal_alb" {
  name        = "${var.name}-scanning-portal-alb"
  description = "Allow access to our alb"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      name = "${var.name}-scanning-portal-alb"
    }
  )
}

resource "aws_security_group" "scanning_portal_container" {
  name        = "${var.name}-scanning-portal-ecs"
  description = "Allow access to our ecs containers"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      name = "${var.name}-scanning-portal-ecs"
    }
  )
}

resource "aws_security_group_rule" "allow_alb_https_egress_to_ecs" {
  description = "Allow https access to our ecs containers"

  from_port = 443
  protocol  = "tcp"
  to_port   = 443
  type      = "egress"

  security_group_id        = aws_security_group.scanning_portal_alb.id
  source_security_group_id = aws_security_group.scanning_portal_container.id
}

resource "aws_security_group_rule" "allow_https_ingress_on_container_from_alb" {
  description = "Allow https access to our ecs containers"

  from_port = 443
  protocol  = "tcp"
  to_port   = 443
  type      = "ingress"

  security_group_id        = aws_security_group.scanning_portal_container.id
  source_security_group_id = aws_security_group.scanning_portal_alb.id
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_https_ingress_on_alb_from_world" {
  description = "Allow https access to our alb"

  from_port = 443
  protocol  = "tcp"
  to_port   = 443
  type      = "ingress"

  security_group_id = aws_security_group.scanning_portal_alb.id
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_http_ingress_on_alb_from_world" {
  description = "Allow http access to our alb"

  from_port = 80
  protocol  = "tcp"
  to_port   = 80
  type      = "ingress"

  security_group_id = aws_security_group.scanning_portal_alb.id
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_https_egress_from_container_to_world" {
  description = "Allow https access to our ecs containers"

  from_port = 443
  protocol  = "tcp"
  to_port   = 443
  type      = "egress"

  security_group_id = aws_security_group.scanning_portal_container.id
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
}
