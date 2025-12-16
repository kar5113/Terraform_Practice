resource "aws_instance" "example" {
  ami           = var.ami-id
  instance_type = var.instance_type
  security_groups= [aws_security_group.allow_all.name]  
  tags = merge(
    local.common_tags,
    {
      Name= "${local.common_name}-tfvars-multi-env"
      }
  )
  
}

resource "aws_security_group" "allow_all" {
  name = "${local.common_name}-tfvars-multi-env"
  description = "Allow all inbound traffic"

  egress {
    from_port        = var.sg_port
    to_port          = var.sg_port
    protocol         = var.sg_protocol #-1 means all protocols
    cidr_blocks      = var.sg_cidr

  }
  ingress {
    from_port        = var.sg_port
    to_port          = var.sg_port
    protocol         = var.sg_protocol
    cidr_blocks      = var.sg_cidr

  }
   tags = merge(
    local.common_tags,
    {
      Name= "${local.common_name}-tfvars-multi-env"
      }
  )
}