locals{
    common_name_suffix = "${var.project}-${var.environment}"
    
    backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value

    private_subnet_cidrs = split(",", data.aws_ssm_parameter.private_subnet_cidrs.value)

    common_tags = {
            Project     = var.project
            Environment = var.environment
            Terraform   = "true"
        }
    
}