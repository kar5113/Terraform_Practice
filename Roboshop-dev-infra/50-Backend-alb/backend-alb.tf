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

resource "aws_route53_record" "backend_alb" {
  zone_id = "Z0806995L2997E89SFOF"
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    # These are ALB details, not our domain details
    name                   = aws_lb.backend-alb.dns_name
    zone_id                = aws_lb.backend-alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}
