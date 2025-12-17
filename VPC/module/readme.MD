Documentation for the VPC Module
===============================

This module creates a Virtual Private Cloud (VPC) with associated subnets, route tables, and optional VPC peering connection.
## Inputs
- Mandatory Inputs
    - `vpc_cidr`: The CIDR block for the VPC.
    - `public_subnet_cidrs`: A map of CIDR blocks for public subnets.
    - `private_subnet_cidrs`: A map of CIDR blocks for private subnets.
    - `database_subnet_cidrs`: A map of CIDR blocks for database subnets.
    - `is_peering_required`: A boolean to indicate if VPC peering is required (default: false).
- Optional Inputs
    - `tags`: A map of tags to assign to the VPC and its resources.
        
## Outputs
- `vpc_id`: The ID of the created VPC.
- `public_subnet_ids`: A list of IDs for the created public subnets.
- `private_subnet_ids`: A list of IDs for the created private subnets.
- `database_subnet_ids`: A list of IDs for the created database subnets.    


## Description
This Terraform module provisions a VPC with customizable CIDR blocks for public, private, and database subnets. It also includes an optional feature to create a VPC peering connection with the default VPC in the same AWS account. When `is_peering_required` is set to true, the module will create a VPC peering connection and configure the necessary route tables to enable communication between the two VPCs.

This module creates the following resources:
- VPC
- Internet Gateway
- Public Subnets
- NAT Gateways
- Private Subnets
- Database Subnets
- Route Tables and Associations
- Optional VPC Peering Connection
