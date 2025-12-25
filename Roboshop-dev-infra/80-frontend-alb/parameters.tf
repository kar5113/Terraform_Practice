resource "aws_ssm_parameter" "this" {
  name  = "/${var.project}/${var.environment}/frontendlb_arn"  
  type  = "String"
  value = aws_lb_listener.frontend-alb.arn
  overwrite= true
}