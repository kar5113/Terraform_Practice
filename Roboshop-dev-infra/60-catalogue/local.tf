locals{
    ami_id=data.aws_ami.ami.id
    # catalogue_sg_id=data.aws_ssm_parameter.catalogue_sg.value
    common_tags={
        Project=var.project
        Environment=var.environment
        terraform ="true"
    }
    common_name_suffix="${var.project}-${var.environment}"

    # private_subnet_id=split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]
}