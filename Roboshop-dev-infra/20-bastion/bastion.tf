resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_id
  vpc_security_group_ids = [local.bastion_sg_id]  
  root_block_device {
    volume_size = 50
  }
# Install terraform, ansible , git here
  user_data = file("${path.module}/configure.sh")

#  Attach IAM Role to the EC2 Instance  
  iam_instance_profile= aws_iam_instance_profile.Bastion_profile.name


  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-bastion"
        }
    )
}

resource "aws_route53_record" "bastion" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "bastion-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 3
  records = [aws_instance.bastion.public_ip]
  allow_overwrite  = true
}

resource "aws_iam_role" "Bastion" {
  name = "${var.project}-${var.environment}-bastion"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-bastion-role"
        }
    )
}

resource "aws_iam_role_policy_attachment" "Bastion_attach" {
  role       = aws_iam_role.Bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

   
}

resource "aws_iam_instance_profile" "Bastion_profile" {
  name = "${var.project}-${var.environment}-bastion-profile"
  role = aws_iam_role.Bastion.name

  depends_on = [aws_iam_role_policy_attachment.Bastion_attach]
}


