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
- create an iam role with necessary policies to allow the bastion to create resources in the account.(probably admin access for now)
- Attach the iam role to the ec2 instance.

Next process with adding SG rules and creating database resources.

## 30-SG rules:
This module adds necessary rules to the security groups created in 10-SG module.
- Add a rule to allow ssh from internet or specific ip to bastion SG.
- Add a rule to allow ssh from bastion SG to all other SGs except frontend stuff.
- all backend services, frontend must have a rule to allow http to backend load balancer SG.
- frontend must have a rule to allow http to frontend load balancer SG.
- all backend services must have a rule to allow http from backend load balancer SG.
- mongodb SG must have a rule to allow mongodb port from catalogue and user SGs.
- mysql SG must have a rule to allow mysql port from cart, shipping SGs
- redis SG must have a rule to allow redis port from cart,user SG.
- rabbitmq SG must have a rule to allow amqp port from payment SG.
- SG rules are added following least privilege principle.



## 40-Databases:
This module creates all the database resources required for the Roboshop application.
- Create a mongodb instance in database subnet.
- Create a mysql instance in database subnet.
- Create a redis cluster in database subnet.
- Create a rabbitmq instance in database subnet.

Use the ansible playbooks for their configuration after the instances are created.
- Database endpoints are outputted to ssm parameter store for other modules to use.
- mysql must require access from ssm parameter to read the password for the mysql root user.

## 50-Backend load balancer:
This module creates a load balancer for the backend of Roboshop application.
- Create an application load balancer in private subnets for backend services.
- create a basic default listener on port 80. 
- DNS record is also created in route53 for the load balancers.

## 60-catalogue:
This module creates the catalogue service resources for the Roboshop application.
This module is the first backend service, so it was created for just test purpose.

Create a module from this and use that moduole to create all the other backend and frontend services.
- Create an ec2 instance in private subnet with necessary SG.
- Use user data to install and configure the service.( with remote exec from bastion and ansible playbook)
- now stop the instance and create an ami from it.
- now create a launch template from the ami.
- now create a target group with service port as 8080 , with a health check path /health.
- Now create autoscaling groups for all the services with min, max, desired counts. use launch template and target groups created above.
- create an instance refresh as well to update the instances in the autoscaling group whenever there is a change in launch template.
- Then create a scaling policy to scale up and down based on cpu utilization.
- Now add  listener rules to the already created basic listener with path based routing.
- Use host header. For example catalogue-dev.kardev.space -> catalogue TG with a priority 10 or any unique value. Similarly add a rule for all the other services.
- Now the original instance can be deleted as the autoscaling group will take care of creating and managing the instances.
- Service endpoints are outputted to ssm parameter store for other modules to use.

## 70-acm:
This module creates an acm certificate for the roboshop application.
- Create a certificate for *.dev.kardev.space in us-east-1 region as the cloudfront requires the certificate to be in us-east-1 region.
- Use dns validation for the certificate.
- Create a route53 record for the validation.

## 80-Frontend load balancer:
This module creates a load balancer for the frontend of Roboshop application.
- Create an application load balancer in public subnets for frontend service.
- create a basic default listener on port 80. 
- create another listener on port 443 with the acm certificate created in 70-acm module.
- create a redirect rule from http to https in port 80 listener.


## 90-Components:
This module creates the all service resources for the Roboshop application. This is an actual module to create all the services.
Create a module from 60-catalogue and use that moduole to create all the other backend and frontend services.
- Create an ec2 instance in private subnet with necessary SG.
- Use user data to install and configure the service.( with remote exec from bastion and ansible playbook)
- now stop the instance and create an ami from it.
- now create a launch template from the ami.
- now create a target group with service port as 8080 for backend services and 80 for frontend service.
- include health checks in the target group.
- Now create autoscaling groups for all the services with min, max, desired counts. use launch template and target groups created above.
- create an instance refresh as well to update the instances in the autoscaling group whenever there is a change in launch template.
- Then create a scaling policy to scale up and down based on cpu utilization.
- Now add  listener rules to the already created basic listener with path based routing.
- Use host header. For example catalogue-dev.kardev.space -> catalogue TG with a priority 10 or any unique value. Similarly add a rule for all the other services.
- For. frontend service, create a separate frontend load balancer module and add listener rule for frontend service with frontend target group on port 80.
- Now the original instance can be deleted as the autoscaling group will take care of creating and managing the instances.
- Service endpoints are outputted to ssm parameter store for other modules to use.





While adding credentials , follow
 aws configure --profile <profile_name> and then provide the access key , secret key and region details.



 The actual flow is :

   1. Create a VPC using 00-VPC module.
   2. Create security groups using 10-SG module.
   3. Create a bastion host using 20-Bastion module.
   4. Add security group rules using 30-SG rules module.
   5. Create database resources using 40-Databases module.
   6. Create backend load balancer using 50-Backend load balancer module.
   7. Create a certificate using 70-acm module.
   8. Create frontend load balancer using 80-Frontend load balancer module.
   9. Create all the service resources using 90-Components module.
   10. A VPN can also be created for secure access to the VPC if required. use openvpn or aws vpn services for that.
   11. A CDN can also be created in front of frontend load balancer for better performance. use cloudfront for that.

Finally , the roboshop application environment is ready with all the necessary resources created using terraform.




