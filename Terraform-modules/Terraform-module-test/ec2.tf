# These are mock values for testing the module Terraform-modules/terraform-module-dev
module "ec2_instance" {
    source =  "../terraform-module-dev" # path to the module if present in local system or else git url or else registry path
    ami_id=var.ami_id   # you can use variables, locals, dataproviders etc to provide valies to module inputs similar to normal terraform code
    instance_type = "t3.micro"
    sg_ids = ["sg-0bb1c123456789abc","sg-0bb1c987654321def"]
    ec2_tags = {
        Name = "Dev-EC2-Instance"
        Environment = "Dev"
    }
}
# output must be provided by the module 
output "ec2_public_ip" {
    value = module.ec2_instance.public_ip
    description = "The public IP address of the EC2 instance from the module"
}

output "ec2_private_ip" {
    value = module.ec2_instance.private_ip
    description = "The private IP address of the EC2 instance from the module"
}