resource "aws_instance" "roboshop" {
  count=length(var.instances)

  ami           = var.ami-id
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name]  
  tags = {
    Name=var.instances[count.index]
  }
}
variable "instances" {
  default=["mongodb","sql","rabbitmq","catalogue","user"]
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

resource "aws_route53_record" "roboshop" {
 count= length(var.instances)
  zone_id = var.zone_id
  name    = "${var.instances[count.index]}.${var.domain_name}"
  type    = "A"
  ttl     = 3
  records = [aws_instance.roboshop[count.index].private_ip]
  allow_overwrite = true
}