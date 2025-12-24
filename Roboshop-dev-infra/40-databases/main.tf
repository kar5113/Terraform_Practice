resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]  
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-mongodb"
        }
    )
    associate_public_ip_address = false
}

resource "aws_route53_record" "mongodb" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "mongodb-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

# or this can be done using data in ec2 resource, refer docker ec2 creation file or null resource
resource "terraform_data" "bootstrap" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
 # terraform copies the bootstrap.sh file from local to remote server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb dev"
     ]
  }
 

  connection {
    type        = "ssh"
    host        = aws_instance.mongodb.private_ip
    user        = "ec2-user"
    password = "DevOps321"
  }
}



# Do the same similarly for all the other db resources.
# for my sql, create an iam role and policy for the incstance to access ssm parameter for mysql root pwd
# attach the iam role to mysql ec2 instance
