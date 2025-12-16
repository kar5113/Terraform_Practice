variable "vpc_cidr" {
    type = string
    description = "The CIDR block for the VPC"
}

variable "project_name" {
    type= string
    description = "The name of the project"
}

variable "environment"{
    type = string
    description = "value of the environment (e.g., dev, prod)"
}

variable "vpc_tags"{
    type = map
    description = "A map of tags to assign to the VPC"
    default={}
}

variable "igw_tags"{
    type = map
    description = "A map of tags to assign to the Internet Gateway"
    default = {}

}

variable "public_subnet_tags"{
    type = map
    description = "A map of tags to assign to the Subnet"
    default = {}

}

variable "public_subnet_cidrs"{
    type = list
    description = "A list of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs"{
    type = list
    description = "A list of CIDR blocks for private subnets"
}

variable "private_subnet_tags"{
    type = map
    description = "A map of tags to assign to the private Subnet"
    default = {}
}

variable "database_subnet_cidrs"{
    type = list
    description = "A list of CIDR blocks for database subnets"
}

variable "database_subnet_tags"{
    type = map
    description = "A map of tags to assign to the database Subnet"
    default = {}
}

variable "public_route_table_tags"{
    type = map
    description = "A map of tags to assign to the public route table"
    default = {}
}

variable "private_route_table_tags"{
    type = map
    description = "A map of tags to assign to the public route table"
    default = {}
}

variable "database_route_table_tags"{
    type = map
    description = "A map of tags to assign to the public route table"
    default = {}
}

variable "nat_gateway_tags"{
    type = map
    description = "A map of tags to assign to the NAT Gateway"
    default = {}
}