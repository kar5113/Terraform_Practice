# Security goup rule to allow HTTP traffic from ALB to Frontend SG on port 80
resource "aws_security_group_rule" "frontend-frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id= local.frontend-alb-sg-id
  security_group_id = local.frontend-sg-id
  description       = "Allow HTTP traffic from ALB to Frontend SG"
}

# SG rule to allow http traffic from internet to frontend ALB on port 80
resource "aws_security_group_rule" "frontend_alb-internet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = local.frontend-alb-sg-id
  description       = "Allow HTTP traffic from internet to Frontend ALB"
}

# SG rule to allow http traffic from internet to frontend ALB on port 80

# Security group rule to allow HTTPS traffic from backend alb to catalogue sg on port 80

# mongodb from bastion

resource "aws_security_group_rule" "mongodb-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion-sg-id
  security_group_id = local.mongodb-sg-id
  description       = "Allow Mongodb traffic from bastion to Mongodb SG"
}