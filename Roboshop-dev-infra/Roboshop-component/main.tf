# create ec2 instance and configure it similar to databases.
resource "aws_instance" "main" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id
  vpc_security_group_ids = [local.component_sg_id]  

    # Doesnt work properly, its inconsisitent. Works sometimes and fails sometimes. Keep it as example placeholder.
    # user_data = file("${path.module}/bootstrap.sh")
    # user_data_replace_on_change = true
  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-${var.component}"
        }
    )
     associate_public_ip_address = false
}

# Create Route53 record for catalogue service
resource "aws_route53_record" "main" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "${var.component}-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 3
  records = [aws_instance.main.private_ip]
  allow_overwrite  = true
}

# bootstrap the catalogue service using terraform provisioners
resource "terraform_data" "main" {
  triggers_replace = [
    aws_instance.main.id
  ]
  # terraform copies the bootstrap.sh file from local to remote server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
       "sudo sh /tmp/bootstrap.sh ${var.component} ${var.environment}"
     ]
  }
  connection {
    type        = "ssh"
    host        = aws_instance.main.private_ip
    user        = "ec2-user"
    password    = "DevOps321"
  }
}

# stop the instance
resource "aws_ec2_instance_state" "main" {
  instance_id = aws_instance.main.id
  state       = "stopped"
  depends_on = [ terraform_data.main ] 
}

# create an ami using the stopped instance
resource "aws_ami_from_instance" "main" {
  name               = "${var.component}-ami-${var.environment}"
  source_instance_id = aws_instance.main.id
  depends_on = [ aws_ec2_instance_state.main ]
}

# create a launch template using that ami
resource "aws_launch_template" "main" {
  name = "${local.common_name_suffix}-${var.component}"

  image_id = aws_ami_from_instance.main.id

  instance_type = "t3.micro"
 
  instance_initiated_shutdown_behavior = "terminate"

  vpc_security_group_ids = [local.component_sg_id]

  # when we run terraform apply again, a new version will be created with new AMI ID
  update_default_version = true

  # tags for the launch template resource
  tag_specifications {
   resource_type = "instance"

    tags =  merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-${var.component}-launch-template"
        }
    )
  }

  #tags for the volumes created using this launch template
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-${var.component}"
      }
    )
  }

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-${var.component}"
      }
    )
}

# create a target group for catalogue service
resource "aws_lb_target_group" "main" {
  name        = "${local.common_name_suffix}-${var.component}-tg"
  # target_type = "instance" # default
  port        =  local.tg_port
  protocol    = "HTTP"
  # protocol_version = "HTTP1"
  # ip_address_type= "ipv4"
  vpc_id      = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance


    health_check {
        # Defaults to true
        enabled = true
        protocol = "HTTP"
        path = local.health_check_path
        port = local.tg_port
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 5
        interval = 10
        matcher = "200-299"
    }
}

# Autoscaling group for catalogue service
resource "aws_autoscaling_group" "main" {
  name                      = "${local.common_name_suffix}-${var.component}-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  vpc_zone_identifier = local.private_subnet_ids


  target_group_arns = [aws_lb_target_group.main.arn]

    # When the launch template is updated with new ami, this will trigger rolling update
    instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

   dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-${var.component}"
      }
    )
    content {
      key                 = tag.key
      propagate_at_launch = true
      value               = tag.value
    }
  }
  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "main" {
  name                   = "${local.common_name_suffix}-${var.component}-scale-out"
 
  autoscaling_group_name = aws_autoscaling_group.main.name

  policy_type = "TargetTrackingScaling"

   target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 85.0
  }
}

# create a lb listener rule
resource "aws_lb_listener_rule" "main" {
  listener_arn= local.listener_arn
  priority = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
        values = [local.host_context]
    }
  }
}

# remove the originally created instance
resource "terraform_data" "main_local" {
  triggers_replace = [
    aws_instance.main.id
  ]
  
  depends_on = [aws_autoscaling_policy.main]
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.main.id}"
  }
}



