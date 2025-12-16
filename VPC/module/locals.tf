locals{
    common_tags={
        Project=var.project_name
        Environment=var.environment
        Terraform = true
    }
    common_name_suffix= "${var.project_name}-${var.environment}" # e.g., projectname-dev
    availability_zones = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
}