# create ec2 instance and configure it similar to databases.
resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id
  vpc_security_group_ids = [local.catalogue_sg_id]  

    # Doesnt work properly, its inconsisitent. Works sometimes and fails sometimes. Keep it as example placeholder.
    # user_data = file("${path.module}/bootstrap.sh")
    # user_data_replace_on_change = true
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-catalogue"
        }
    )
    # associate_public_ip_address = false
}

resource "aws_route53_record" "catalogue" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "catalogue-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 3
  records = [aws_instance.catalogue.public_ip]
  allow_overwrite  = true
}

resource "terraform_data" "bootstrap" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  # terraform copies the bootstrap.sh file from local to remote server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
       "sudo sh /tmp/bootstrap.sh catalogue dev"
     ]
  }
  connection {
    type        = "ssh"
    host        = aws_instance.catalogue.public_ip
    user        = "ec2-user"
    password = "DevOps321"
  }
}


# stop the instance and create an ami from it.

# Create a launch template using that ami

# create a target group for catalogue service

# Use that launch template in the autoscaling group for catalogue service and attach the target group to it.

