resource "aws_instance" "example" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name]  
  tags = {
    Name = "HelloWorld"
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