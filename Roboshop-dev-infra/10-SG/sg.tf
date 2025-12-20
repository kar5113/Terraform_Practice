module "security_groups"{
   source= "../../SG/module"

   count= length(var.sg_names)
   sg_name ="${local.common_name_suffix}-${var.sg_names[count.index]}"
   sg_description = "Security groups for Roboshop application"
   vpc_id =  data.aws_ssm_parameter.vpc_id.value
   project = var.project
   environment = var.environment
}