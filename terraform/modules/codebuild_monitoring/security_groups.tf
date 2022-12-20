resource "aws_security_group" "grafana_db_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-codebuild-grafana-db-sg"
  description = "Allow ingress/egress to the grafana db"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-codebuild-grafana-db-sg"
    }
  )
}

resource "aws_security_group" "grafana_cluster_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-codebuild-grafana-cluster-sg"
  description = "Allow ingress/egress to the grafana cluster"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-codebuild-grafana-cluster-sg"
    }
  )
}

resource "aws_security_group" "grafana_alb_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-codebuild-grafana-alb-sg"
  description = "Allow ingress/egress to the grafana alb"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-codebuild-grafana-alb-sg"
    }
  )
}

resource "aws_security_group_rule" "allow_db_ingress_from_grafana_containers" {
  description = "Allow ingress to postgres from grafana"

  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"
  type      = "ingress"

  security_group_id        = aws_security_group.grafana_db_security_group.id
  source_security_group_id = aws_security_group.grafana_cluster_security_group.id
}

resource "aws_security_group_rule" "allow_grafana_egress_to_db" {
  description = "Allow egress to postgres from grafana"

  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"
  type      = "egress"

  security_group_id        = aws_security_group.grafana_cluster_security_group.id
  source_security_group_id = aws_security_group.grafana_db_security_group.id
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_grafana_container_egress_to_world" {
  description = "Allow egress to the world from grafana ecs container"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  type      = "egress"

  security_group_id = aws_security_group.grafana_cluster_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_grafana_alb_http_ingress" {
  description = "Allow http ingress to our grafana alb"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  type        = "ingress"

  security_group_id = aws_security_group.grafana_alb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_grafana_alb_https_ingress" {
  description = "Allow https ingress to our grafana alb"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  type        = "ingress"

  security_group_id = aws_security_group.grafana_alb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_grafana_alb_https_egress_to_grafana" {
  description = "Allow alb http egress to containers"

  from_port = 3000
  to_port   = 3000
  protocol  = "tcp"
  type      = "egress"

  security_group_id        = aws_security_group.grafana_alb_security_group.id
  source_security_group_id = aws_security_group.grafana_cluster_security_group.id
}

resource "aws_security_group_rule" "allow_grafana_alb_https_ingress_to_grafana" {
  description = "Allow alb https ingress to containers"

  from_port = 3000
  to_port   = 3000
  protocol  = "tcp"
  type      = "ingress"

  source_security_group_id = aws_security_group.grafana_alb_security_group.id
  security_group_id        = aws_security_group.grafana_cluster_security_group.id
}
