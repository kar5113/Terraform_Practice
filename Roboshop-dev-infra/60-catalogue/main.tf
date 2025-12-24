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
     associate_public_ip_address = false
}

# Create Route53 record for catalogue service
resource "aws_route53_record" "catalogue" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "catalogue-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 3
  records = [aws_instance.catalogue.private_ip]
  allow_overwrite  = true
}

# bootstrap the catalogue service using terraform provisioners
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
    host        = aws_instance.catalogue.private_ip
    user        = "ec2-user"
    password    = "DevOps321"
  }
}

# stop the instance
resource "aws_ec2_instance_state" "stop_catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
}

# create an ami using the stopped instance
resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "catalogue-ami-${var.environment}-${timestamp()}"
  source_instance_id = aws_instance.catalogue.id
}

# create a launch template using that ami
resource "aws_launch_template" "catalogue_launch_template" {
  name = "catalogue-${var.environment}"
  image_id = aws_ami_from_instance.catalogue_ami.id
  instance_type = "t3.micro"
  placement {
    availability_zone = local.private_subnet_id
  }
  vpc_security_group_ids = [local.catalogue_sg_id]

  tag_specifications {
    service = "catalogue-${var.environment}"

    tags =  merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-catalogue-launch-template"
        }
    )
  }
}

# create a target group for catalogue service




# stop the instance and create an ami from it.

# Create a launch template using that ami

# create a target group for catalogue service

# Use that launch template in the autoscaling group for catalogue service and attach the target group to it.

