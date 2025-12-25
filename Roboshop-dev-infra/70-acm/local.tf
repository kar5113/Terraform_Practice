locals{
    common_name_suffix="${var.project}-${var.environment}"
    common_tags={
        project=var.project
        environment=var.environment
        terraform="true"
    }
}