resource "aws_instance" "example" {
  ami           = local.ami_id.id
  instance_type = local.instance-type
  security_groups= [aws_security_group.allow_all.name]  
  tags =  merge(
      var.common_tags,
      {
      Name = "${local.common_name}-demo"
    }
    )
  
}

variable "common_tags" {
  type=map
  default={
    Project= "instana"
    Environment="dev"
    Application="roboshop"
    Terraform=true
  } 
}

resource "aws_security_group" "allow_all" {
  name = "${local.common_name}-allow-all"
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