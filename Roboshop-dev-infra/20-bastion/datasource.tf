data "aws_ami" "ami" { 
    most_recent      = true
    owners           = ["973714476881"]

    filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}

data "aws_ssm_parameter" "bastion_sg" {
  name = "${var.project}/${var.environment}/bastion-sg_sg_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "${var.project}/${var.environment}/public_subnet_ids"
}