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
resource "terraform_data" "mongodb" {
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

# redis
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [local.redis_sg_id]  
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-redis"
        }
    )
    associate_public_ip_address = false
}

resource "aws_route53_record" "redis" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "redis-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

# or this can be done using data in ec2 resource, refer docker ec2 creation file or null resource
resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
 # terraform copies the bootstrap.sh file from local to remote server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis dev"
     ]
  }
 
  connection {
    type        = "ssh"
    host        = aws_instance.redis.private_ip
    user        = "ec2-user"
    password = "DevOps321"
  }
}


# My sql
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [local.mysql_sg_id]  
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-mysql"
        }
    )
    associate_public_ip_address = false
}

resource "aws_iam_role" "mysql" {
  name = "${var.project}-${var.environment}-mysql"

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
            Name= "${local.common_name_suffix}-mysql-role"
        }
    )
}

resource "aws_iam_policy" "mysql" {
  name        = "${var.project}-${var.environment}-mysql-ssm-policy"
  path        = "/"
  description = "Policy to allow EC2 instances to read SSM parameters"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"ssm:GetParameterHistory",
				"ssm:GetParametersByPath",
				"ssm:GetParameters",
				"ssm:GetParameter"
			],
			"Resource": "arn:aws:ssm:us-east-1:842747763415:parameter/roboshop/my_sql/root_password"
		}
	]
})
}

resource "aws_iam_role_policy_attachment" "mysql" {
  role       = aws_iam_role.mysql.name
  policy_arn = aws_iam_policy.mysql.arn

}

resource "aws_iam_instance_profile" "mysql" {
  name = "${var.project}-${var.environment}-mysql"
  role = aws_iam_role.mysql.name

  depends_on = [aws_iam_role_policy_attachment.mysql]
}



resource "aws_route53_record" "mysql" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "mysql-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}

# or this can be done using data in ec2 resource, refer docker ec2 creation file or null resource
resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]
 # terraform copies the bootstrap.sh file from local to remote server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql dev"
     ]
  }
 
  connection {
    type        = "ssh"
    host        = aws_instance.mysql.private_ip
    user        = "ec2-user"
    password = "DevOps321"
  }
}


# RabbitMq
resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [local.rabbitmq_sg_id]  
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-rabbitmq"
        }
    )
    associate_public_ip_address = false
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "rabbitmq-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}

# or this can be done using data in ec2 resource, refer docker ec2 creation file or null resource
resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]
 # terraform copies the bootstrap.sh file from local to remote server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq dev"
     ]
  }
 
  connection {
    type        = "ssh"
    host        = aws_instance.rabbitmq.private_ip
    user        = "ec2-user"
    password = "DevOps321"
  }
}



# Do the same similarly for all the other db resources.
# for my sql, create an iam role and policy for the incstance to access ssm parameter for mysql root pwd
# attach the iam role to mysql ec2 instance
