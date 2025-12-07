terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "Docker-roboshop" {

  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name] 
  # root_block_device {
  #   volume_size = 50
  # }
  user_data = file("${path.module}/volume-change.sh")
user_data_replace_on_change = true
  tags = {
    Name = "Docker"
  }
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
