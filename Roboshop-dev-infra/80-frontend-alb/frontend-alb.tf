resource "aws_lb" "frontend-alb" {
  name               = "${local.common_name_suffix}-frontend-alb"  #roboshop-dev-frontend-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_sg_id]
  subnets            = local.public_subnet_cidrs

  enable_deletion_protection = true 

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-frontend-alb"
    }
  )
}



resource "aws_lb_listener" "frontend-alb" {
  load_balancer_arn = aws_lb.frontend-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = local.frontend_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "backend_alb" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "roboshop-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    # These are ALB details, not our domain details
    name                   = aws_lb.frontend-alb.dns_name
    zone_id                = aws_lb.frontend-alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}
