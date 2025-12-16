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
    provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginxs" 
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.ssh_private_key)
      # or , key or password any one is necessary
      password = "DevOps321"
      host        = self.public_ip
    }
  }
  instance_initiated_shutdown_behavior = "terminate"
  
}
variable "ssh_private_key" {
  default= "Path/for/private/key/file"
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