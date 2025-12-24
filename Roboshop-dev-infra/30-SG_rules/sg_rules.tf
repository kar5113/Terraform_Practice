# Security goup rule to allow HTTP traffic from ALB to Frontend SG on port 80
resource "aws_security_group_rule" "frontend-frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id= local.frontend_alb_sg_id
  security_group_id = local.frontend_sg_id
  description       = "Allow HTTP traffic from ALB to Frontend SG"
}

# SG rule to allow http traffic from internet to frontend ALB on port 80
resource "aws_security_group_rule" "frontend_alb-internet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = local.frontend_alb_sg_id
  description       = "Allow HTTP traffic from internet to Frontend ALB"
}

# Security group rule to allow ssh connection to bastion from internet
resource "aws_security_group_rule" "bastion-internet" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = local.bastion_sg_id
  description       = "Allow SSH traffic from internet to Bastion SG"
}

# mongodb from bastion ssh connection on port 22
resource "aws_security_group_rule" "mongodb-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.mongodb_sg_id
  description       = "Allow Mongodb traffic from bastion to Mongodb SG"
}

# mysql from bastion ssh connection on port 22
resource "aws_security_group_rule" "mysql-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.mysql_sg_id
  description       = "Allow Mysql traffic from bastion to Mysql SG"
}

# redis from bastion ssh connection on port 22
resource "aws_security_group_rule" "redis-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.redis_sg_id
  description       = "Allow Redis traffic from bastion to Redis SG"
}

# rabbitmq from bastion ssh connection on port 22
resource "aws_security_group_rule" "rabbitmq-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.rabbitmq_sg_id
  description       = "Allow Rabbitmq traffic from bastion to Rabbitmq SG"
}

# payment from bastion ssh connection on port 22
resource "aws_security_group_rule" "payment-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.payment_sg_id
  description       = "Allow Payment traffic from bastion to Payment SG"
}

# shipping from bastion ssh connection on port 22
resource "aws_security_group_rule" "shipping-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.shipping_sg_id
  description       = "Allow Shipping traffic from bastion to Shipping SG"
}

# user from bastion ssh connection on port 22
resource "aws_security_group_rule" "user-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.user_sg_id
  description       = "Allow User traffic from bastion to User SG"
}

# cart from bastion ssh connection on port 22
resource "aws_security_group_rule" "cart-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.cart_sg_id
  description       = "Allow Cart traffic from bastion to Cart SG"
}

# catalogue from bastion ssh connection on port 22
resource "aws_security_group_rule" "catalogue-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.catalogue_sg_id
  description       = "Allow Catalogue traffic from bastion to Catalogue SG"
}

# catalogue from bastion http connection on port 80
resource "aws_security_group_rule" "catalogue-bastion-http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.catalogue_sg_id
  description       = "Allow Catalogue traffic from bastion to Catalogue SG"
}



# Allow catalogue to communicate with mongodb on port 27017
resource "aws_security_group_rule" "mongodb-catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id= local.catalogue_sg_id
  security_group_id = local.mongodb_sg_id
  description       = "Allow Catalogue SG to communicate with Mongodb SG"
}




