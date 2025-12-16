# without default value, this variable becomes mandatory to provide during module call
variable "ami_id" {
   # giving a default makes it optional to provide during module call, but can be overridden
    type= string
    default="ami-09c813fb71547fc4f"
    description = "This is the AMI ID for the EC2 instance"
}

variable "instance_type" {
    type = string
   # for controlling user inputs we can add validation blocks, refer terraform docs for more details
    validation {
        condition= contains(["t3.micro","t3.small","t3.medium","t3.large"], var.instance_type)
        error_message= "Invalid instance type provided. Allowed types are t3.micro, t3.small, t3.medium, t3.large"
    }
    description = "This is the instance type for the EC2 instance"
}

variable "sg_ids"{
    type= list
 
    description="This is to attach multiple security groups to the EC2 instance"
}

variable "ec2_tags" {
    type = map
    default={}  # this empty map will make this ec2_tags variable optional
    description = "Tags for the ec2 tags"
}

