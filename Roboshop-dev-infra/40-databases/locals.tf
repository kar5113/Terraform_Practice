locals{
    ami_id=data.aws_ami.ami.id
    mongodb_sg_id=data.aws_ssm_parameter.mongodb_sg.value
    common_tags={
        Project=var.project
        Environment=var.environment
        terraform ="true"
    }
    common_name_suffix="${var.project}-${var.environment}"

    database_subnet_id=split(",",data.aws_ssm_parameter.database_subnet_ids.value)[0]
}