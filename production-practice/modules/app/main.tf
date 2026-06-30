resource "aws_security_group" "app" {
  // Base app security group; specific inbound rules are added below.
  name        = substr("${local.name_prefix}-sg", 0, 255)
  description = "Security group for ${var.app_name}"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = toset(var.allowed_cidr_blocks)

  security_group_id = aws_security_group.app.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = var.container_port
  to_port           = var.container_port
}

resource "aws_vpc_security_group_ingress_rule" "sg" {
  for_each = toset(var.allowed_security_group_ids)

  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = each.value
  ip_protocol                  = "tcp"
  from_port                    = var.container_port
  to_port                      = var.container_port
}

resource "aws_lb_target_group" "release" {
  // One target group per release track so traffic can be shifted between them.
  for_each = local.release_sets

  name_prefix = substr("${local.app_key}-${each.key}", 0, 6)
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  deregistration_delay = 30

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = var.health_check_path
    port                = tostring(var.container_port)
    timeout             = 5
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}-tg"
  })
}

resource "aws_launch_template" "release" {
  // Launch template holds the AMI and bootstrap data for each release track.
  for_each = local.release_sets

  name_prefix   = substr("${local.name_prefix}-${each.key}-", 0, 20)
  image_id      = each.value.ami_id
  instance_type = each.value.instance_type

  update_default_version = true

  network_interfaces {
    security_groups             = [aws_security_group.app.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    app_name        = var.app_name
    environment     = var.environment
    deployment_type = var.deployment_type
    deployment_mode = var.deployment_action
    release_name    = each.key
    container_port  = var.container_port
  }))

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name    = "${local.name_prefix}-${each.key}"
      Release = each.key
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-${each.key}-volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}-lt"
  })
}

resource "aws_autoscaling_group" "release" {
  // The ASG keeps the application fleet alive and replaces unhealthy instances.
  for_each = local.release_sets

  name                      = substr("${local.name_prefix}-${each.key}-asg", 0, 32)
  min_size                  = each.value.min_size
  max_size                  = each.value.max_size
  desired_capacity          = each.value.desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 120
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.release[each.key].arn]
  force_delete              = false

  launch_template {
    id      = aws_launch_template.release[each.key].id
    version = aws_launch_template.release[each.key].latest_version
  }

  dynamic "instance_refresh" {
    // Rolling updates only refresh the primary track because it represents the active fleet.
    for_each = local.normalized_deployment_type == "rolling" && each.key == "primary" ? [1] : []

    content {
      strategy = "Rolling"

      preferences {
        min_healthy_percentage = 75
        instance_warmup        = 120
      }

      triggers = ["launch_template"]
    }
  }

  dynamic "tag" {
    for_each = merge(local.common_tags, {
      Name    = "${local.name_prefix}-${each.key}-asg"
      Release = each.key
    })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_lb_listener_rule" "app" {
  // Listener rule routes requests by host name and switches traffic by deployment type.
  listener_arn = var.listener_arn
  priority     = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = local.use_secondary ? null : aws_lb_target_group.release["primary"].arn

    dynamic "forward" {
      for_each = local.use_secondary ? [1] : [] 

      content {
        target_group {
          arn    = aws_lb_target_group.release["primary"].arn
          weight = local.primary_weight
        }

        target_group {
          arn    = aws_lb_target_group.release["secondary"].arn
          weight = local.secondary_weight
        }

        dynamic "stickiness" {
          for_each = var.enable_stickiness ? [1] : []

          content {
            enabled  = true
            duration = var.sticky_duration_seconds
          }
        }
      }
    }
  }

  condition {
    host_header {
      values = [var.host_header]
    }
  }
}
