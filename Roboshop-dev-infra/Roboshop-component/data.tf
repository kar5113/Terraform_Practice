data "aws_ami" "ami" { 
    most_recent      = true
    owners           = ["973714476881"]

    filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}

data "aws_ssm_parameter" "component_sg" {
  name = "/${var.project}/${var.environment}/${var.component}_sg_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "backend_alb_arn" {
  name = "/${var.project}/${var.environment}/backendlb_arn"
}

data "aws_ssm_parameter" "frontend_alb_arn" {
  name = "/${var.project}/${var.environment}/frontendlb_arn"
}