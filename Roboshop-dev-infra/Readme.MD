This is the readme file for Roboshop Dev Infra repository.

It contains infrastructure code for setting up the Roboshop application environment using Terraform.


First , we start with networking and with the creation of VPC


## 00-VPC:
This module creates the VPC, Subnets, Internet Gateway, NAT Gateway, Route Tables and necessary associations.
- Create a VPC 
- Create a public(for frontend), private(for backend services) and database subnets in 2 or more availability zones.
- Create an Internet gateway and attach to the VPC.
- create route tables for public, private, database subnets.
- By default all route tables contain local route for VPC cidr, if not create one so that all the resources within VPC can communicate with each other.
- Now, on public route table, create a route for internet gateway.
- Now create an elastic ip for nat gateway.
- Create a nat gateway in public subnwt and attach the elastic ip to it.
- Create a route in private and database route tables to the nat gateway for oneway internet access for private and database subnets.
- Finally associate the route tables to their respective subnets.
- VPC id, subnet ids, route table ids, nat gateway id and internet gateway id are outputted into ssm parameter store for other modules to use.

With this, setting up VPC for Roboshop application is done. Next procees with creating various security groups required for the application.

## 10-SG:
This module creates all the security groups required for the Roboshop application.
- Create security groups for each of services in Roboshop application.
- Various resources are : 
    - Databases: Mongodb, Mysql, Redis, Rabbiotmq
    - Backend: Catalogue, User, Cart, Shipping, Payment
    - Frontend: Nginx or just frontend
    - Loadbalancer: backend load balancer, frontend load balancer
    - Bastion: Bastion or jump server for accessing private , database subnets.
- SG ids are outputted to ssm parameter store for other modules to use.    

While security groups are created now, no ruled are added yet. Add the rules while creating resources for each service so that we follow least privilege principle.
Next proceed with creating a bastion host or jump server.

## 20-Bastion:
This bastion is used to configure the resources in private and database subnets.
- Create an ec2 instance in public subnet with SG rule allowing ssh from internet or specific ip if possible.
- Make sure the instance is created with enough storage as terraform will be installed here.
- Expand the storage for home dir.
- Install terraform and ansible.
- Bastion can be configured with either local exec or aws ec2 data source to run commands on the bastion itself.
- The bastion's public ip is outputted to ssm parameter store for other modules to use.

Next procees with adding SG rules and creating database resources.

## 40-SG rules:
This module adds necessary rules to the security groups created in 10-SG module.
- Add a rule to allow ssh from internet or specific ip to bastion SG.
- Add a rule to allow ssh from bastion SG to all other SGs.
