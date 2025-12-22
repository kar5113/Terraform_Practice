data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "${var.project}/${var.environment}/frontend-alb-sg-id"
}

data "aws_ssm_parameter" "frontend-sg-id" {
  name = "${var.project}/${var.environment}/frontend-sg-id"
}

data "aws_ssm_parameter" "mongodb-sg-id" {
  name = "${var.project}/${var.environment}/mongodb-sg-id"
}

data "aws_ssm_parameter" "bastion-sg-id" {
  name = "${var.project}/${var.environment}/bastion-sg-id"
}

