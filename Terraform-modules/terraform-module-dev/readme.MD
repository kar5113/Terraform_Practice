# Documentation for the EC2 module

This Terraform module provisions an EC2 instance with customizable parameters such as AMI ID, instance type, security groups, and tags.
## Variables
- `ami_id`: (string) The AMI ID for the EC2 instance. (Optional, by default a value is set)
- `instance_type`: (string) The instance type for the EC2 instance. (mandatory)
- `sg_ids`: (list) A list of security group IDs to attach to the EC2 instance. (mandatory)
- `ec2_tags`: (map) A map of tags to assign to the EC2 instance. (Optional, by default an empty map)

## Outputs
- `public_ip`: The public IP address of the created EC2 instance.
- `private_ip`: The private IP address of the created EC2 instance.
## Usage
To use this module, include it in your Terraform configuration as follows:
```hcl
module "ec2_instance" {
  source        = "./path/to/terraform-module-dev"
  ami_id        = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
  sg_ids       = ["sg-0123456789abcdef0"]   
    ec2_tags     = {
        Name        = "MyEC2Instance"
        Environment = "Development"
    }
}
```
## Notes
- Ensure that the specified AMI ID is valid for the region where you are deploying the EC2 instance.
- Adjust the instance type and security groups according to your requirements.
- You can customize the tags to better organize and identify your resources.    
## License
This module is licensed under the MIT License. See the LICENSE file for details.

