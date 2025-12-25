locals{
    common_name_suffix = "${var.project}-${var.environment}"
    
    frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value

    public_subnet_cidrs = split(",", data.aws_ssm_parameter.public_subnet_cidrs.value)

    common_tags = {
            Project     = var.project
            Environment = var.environment
            Terraform   = "true"
        }
        
    frontend_certificate_arn = data.aws_ssm_parameter.frontend_certificate_arn.value
}