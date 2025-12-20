resource "aws_instance" "example" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_ids[0]
  vpc_security_group_ids = [local.bastion_sg_id]  
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-bastion"
        }
    )
}

resource "aws_security_group" "allow_all" {
  name = "allow-all"
    description = "Allow all inbound traffic"

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags={
    Name = "allow-all"
  }
}