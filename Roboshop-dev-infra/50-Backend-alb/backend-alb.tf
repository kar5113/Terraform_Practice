resource "aws_lb" "backend-alb" {
  name               = "${local.common_name_suffix}-backend-alb"  #roboshop-dev-backend-alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_cidrs

  enable_deletion_protection = true 

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-backend-alb"
    }
  )
}

resource "aws_lb_listener" "backend-alb-listener" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}