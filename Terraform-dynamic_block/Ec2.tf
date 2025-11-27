resource "aws_instance" "example" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name]  
  tags = {
    Name = "HelloWorld"
  }
}

variable "ingress_ports"{
  default = [80,8080,2525,27680,443]
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
  dynamic "ingress"{
    for_each=var.ingress_ports
    content{
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  # ingress {
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["0.0.0.0/0"]

  # }

  tags={
    Name = "allow-all"
  }
}