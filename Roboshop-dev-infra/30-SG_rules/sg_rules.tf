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

# frontend from bastion ssh connection on port 22
resource "aws_security_group_rule" "frontend-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.frontend_sg_id
  description       = "Allow Frontend traffic from bastion to Frontend SG"  
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

######################################################################################################################################################

# # Backend services to alb communication security group rules

# catalogue from backend alb http connection on port 8080
resource "aws_security_group_rule" "catalogue-backend-alb-http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.backend_alb_sg_id
  security_group_id = local.catalogue_sg_id
  description       = "Allow Catalogue traffic from backend alb to Catalogue SG"
}

# user from backend alb http connection on port 8080
resource "aws_security_group_rule" "user-backend-alb-http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.backend_alb_sg_id
  security_group_id = local.user_sg_id
  description       = "Allow User traffic from backend alb to User SG"
}

# cart from backend alb http connection on port 8080
resource "aws_security_group_rule" "cart-backend-alb-http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.backend_alb_sg_id
  security_group_id = local.cart_sg_id
  description       = "Allow Cart traffic from backend alb to Cart SG"
}

# shipping from backend alb http connection on port 8080
resource "aws_security_group_rule" "shipping-backend-alb-http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.backend_alb_sg_id
  security_group_id = local.shipping_sg_id
  description       = "Allow Shipping traffic from backend alb to Shipping SG"
}

# payment from backend alb http connection on port 8080
resource "aws_security_group_rule" "payment-backend-alb-http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.backend_alb_sg_id
  security_group_id = local.payment_sg_id
  description       = "Allow Payment traffic from backend alb to Payment SG"
}

######################################################################################################################################################

#  allow catalogue, user to communicate with mongodb on port 27017

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

# Allow user to communicate with mongodb on port 27017
resource "aws_security_group_rule" "mongodb-user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id= local.user_sg_id
  security_group_id = local.mongodb_sg_id
  description       = "Allow User SG to communicate with Mongodb SG"
}

######################################################################################################################################################

# # Allow redis to communicate with user,cart on port 6379

# Allow user to communicate with redis on port 6379
resource "aws_security_group_rule" "redis-user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id= local.user_sg_id
  security_group_id = local.redis_sg_id
  description       = "Allow User SG to communicate with Redis SG"
}

# Allow cart to communicate with redis on port 6379
resource "aws_security_group_rule" "redis-cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id= local.cart_sg_id
  security_group_id = local.redis_sg_id
  description       = "Allow Cart SG to communicate with Redis SG"
}

######################################################################################################################################################

# # Allow mysql to communicate with shipping on port 3306

# Allow shipping to communicate with mysql on port 3306
resource "aws_security_group_rule" "mysql-shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id= local.shipping_sg_id
  security_group_id = local.mysql_sg_id
  description       = "Allow Shipping SG to communicate with Mysql SG"
}

######################################################################################################################################################

# # Allow payment to communicate with rabbitmq on port 5672

resource "aws_security_group_rule" "rabbitmq-payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id= local.payment_sg_id
  security_group_id = local.rabbitmq_sg_id
  description       = "Allow Payment SG to communicate with Rabbitmq SG"
}

######################################################################################################################################################

# Allow cart to communicate with catalogue on port 8080
resource "aws_security_group_rule" "catalogue-cart" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.cart_sg_id
  security_group_id = local.catalogue_sg_id
  description       = "Allow Cart SG to communicate with Catalogue SG"
}

# Allow shipping to communicate with cart on port 8080
resource "aws_security_group_rule" "cart-shipping" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.shipping_sg_id
  security_group_id = local.cart_sg_id
  description       = "Allow Shipping SG to communicate with Cart SG"
}

# Allow payment to communicate with user on port 8080
resource "aws_security_group_rule" "user-payment" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.user_sg_id
  security_group_id = local.payment_sg_id
  description       = "Allow User SG to communicate with Payment SG"
}

# Allow payment to communicate with cart on port 8080
resource "aws_security_group_rule" "cart-payment" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id= local.cart_sg_id
  security_group_id = local.payment_sg_id
  description       = "Allow Cart SG to communicate with Payment SG"
}

######################################################################################################################################################

# Allow frontend to communicate with backend alb on port 80
resource "aws_security_group_rule" "backend-alb-frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id= local.frontend_sg_id
  security_group_id = local.backend_alb_sg_id
  description       = "Allow Frontend SG to communicate with Backend ALB SG"
}

# Allow frontend to communicate with frontend alb on port 80
resource "aws_security_group_rule" "frontend-alb-frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id= local.frontend_sg_id
  security_group_id = local.frontend_alb_sg_id
  description       = "Allow Frontend SG to communicate with Frontend ALB SG"
}

######################################################################################################################################################

# allow http traffic from bastion to Backend ALB SG on port 80
resource "aws_security_group_rule" "backend-bastion-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id= local.bastion_sg_id
  security_group_id = local.backend_alb_sg_id
  description       = "Allow http traffic from bastion to Backend ALB SG"
}


# Allow internet to communicate with froentend ALB on port 443
resource "aws_security_group_rule" "frontend-alb-internet" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = local.frontend_alb_sg_id
  description       = "Allow internet to communicate with frontend ALB on port 443"
}






