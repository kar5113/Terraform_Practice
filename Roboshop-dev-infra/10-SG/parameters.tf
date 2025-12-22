resource "aws_ssm_parameter" "this" {
  count=length(var.sg_names)
  name  = "/${var.project}/${var.environment}/${var.sg_names[count.index]}-sg-id"  # e.g. Roboshop/dev/frontend_sg_id
  type  = "String"
  value = module.security_groups[count.index].sg_id
  overwrite= true
}