resource "aws_ssm_parameter" "foo" {
  count=length(var.sg_names)


  name  = "${var.project}/${var.environment}/${var.sg_names[count.index]}_sg_id"
  type  = "String"
  value = module.security_groups[count.index].sg_id
  overwrite= true
}