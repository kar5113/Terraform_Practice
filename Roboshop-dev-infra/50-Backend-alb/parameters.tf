resource "aws_ssm_parameter" "this" {

  name  = "/${var.project}/${var.environment}/backendlb_arn"  
  type  = "String"
  value = aws_lb.backend-alb.arn
  overwrite= true
}