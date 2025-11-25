resource "aws_instance" "example" {
  ami           = var.ami-id
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name]  
  tags = var.Ec2_tags
  
}

resource "aws_security_group" "allow_all" {
  name = var.sg_name
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
}