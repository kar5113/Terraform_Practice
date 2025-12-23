# create ec2 instance and configure it similar to databases.
resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id
  vpc_security_group_ids = [local.catalogue_sg_id]  
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-catalogue"
        }
    )
    associate_public_ip_address = false
}

resource "aws_route53_record" "catalogue" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "catalogue.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.catalogue.private_ip]
}

# stop the instance and create an ami from it.

# Create a launch template using that ami

# create a target group for catalogue service

# Use that launch template in the autoscaling group for catalogue service and attach the target group to it.

