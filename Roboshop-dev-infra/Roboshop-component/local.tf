locals{
    ami_id=data.aws_ami.ami.id

    component_sg_id=data.aws_ssm_parameter.component_sg.value

    common_tags={
        Project=var.project
        Environment=var.environment
        terraform ="true"
    }
    common_name_suffix="${var.project}-${var.environment}"

    private_subnet_id=split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]

    private_subnet_ids=split(",",data.aws_ssm_parameter.private_subnet_ids.value)

    vpc_id=data.aws_ssm_parameter.vpc_id.value

    backend_alb_arn=data.aws_ssm_parameter.backend_alb_arn.value

    frontend_alb_arn=data.aws_ssm_parameter.frontend_alb_arn.value

    listener_arn= var.component== "frontend" ? local.frontend_alb_arn : local.backend_alb_arn

    host_context = var.component== "frontend" ? "${var.project}-${var.environment}.${var.domain_name}" : "${var.component}.backend-alb-${var.environment}.${var.domain_name}"

    tg_port= var.component == "frontend" ? 80 : 8080

    health_check_path = var.component == "frontend" ? "/" : "/health"
}