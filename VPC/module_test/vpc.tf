module "vpc"{
    source ="../module"
   
   #VPC
    vpc_cidr= var.vpc_cidr
    project_name = var.project_name
    environment = var.environment
    vpc_tags=var.vpc_tags
    
    # Public Subnets
    public_subnet_cidrs= var.public_subnet_cidrs

    # Private Subnets
    private_subnet_cidrs= var.private_subnet_cidrs

    # Database subnets
    database_subnet_cidrs= var.database_subnet_cidrs

}