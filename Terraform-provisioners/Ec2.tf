resource "aws_instance" "example" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name]  
  tags = {
    Name = "HelloWorld"
  }
  provisioner "local-exec" {
    when = create
    command = "echo ${self.private_ip} >> inventory.ini"
    on_failure = continue
  }
  provisioner "local-exec" {
    when = destroy
    command = "rm -f inventory.ini"
    on_failure = continue
  }
  instance_initiated_shutdown_behavior = "terminate"
  
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