# verify naming conventions on terraform documentation

resource "aws_instance" "this" {
  ami           = var.ami_id # mandatory variable now
  instance_type = var.instance_type # mandatory variable now
  security_groups= var.sg_ids   # mandatory variable now
  tags = var.ec2_tags # optional variable now
  
}

