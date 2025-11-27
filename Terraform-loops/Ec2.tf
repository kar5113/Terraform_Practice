# resource "aws_instance" "roboshop" { // for list
#   count=length(var.instances)

#   ami           = var.ami-id
#   instance_type = "t3.micro"
#   security_groups= [aws_security_group.allow_all.name]  
#   tags = {
#     Name=var.instances[count.index]
#   }
# }
variable "instances" {
  default=["mongodb","sql","rabbitmq","catalogue","user"]
}

variable "instances_map" {
  default={
    instance1="mongo"
    instance2="sql"
    instance3="redis"
    instance4="catalogue"
    instance5="payment"
  }
}

resource "aws_instance" "roboshop" {
  for_each = var.instances_map

  ami           = var.ami-id
  instance_type = "t3.micro"
  security_groups= [aws_security_group.allow_all.name]  
  tags = {
    Name = each.value
  }
}



# resource "aws_instance" "roboshop" {. for set
#   for_each = toset(var.instances)

#   ami           = var.ami-id
#   instance_type = "t3.micro"
#   security_groups= [aws_security_group.allow_all.name]  
#   tags = {
#     Name = each.value
#   }
# }



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
 #count= length(var.instances)// for list and set
 for_each= aws_instance.roboshop // for map
  zone_id = var.zone_id
  #name    = "${var.instances[count.index]}.${var.domain_name}" // for set , list
  name= "${each.value.tags.Name}.${var.domain_name}" //for map
  type    = "A"
  ttl     = 3
  records = [each.value.private_ip] // for map
 # records = [aws_instance.roboshop[var.instances[count.index]].private_ip] // for a set
 # records = [aws_instance.roboshop[count.index].private_ip] // for a list
  allow_overwrite = true
}