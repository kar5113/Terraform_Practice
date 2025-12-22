data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "${var.project}/${var.environment}/backend-alb-sg-id"
}

data "aws_ssm_parameter" "private_subnet_cidrs" {
  name = "${var.project}/${var.environment}/private-subnet-cidrs"
}