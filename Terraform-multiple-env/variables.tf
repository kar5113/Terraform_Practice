variable "ami-id" {
    default="ami-09c813fb71547fc4f"  
    type= string
}

variable "project"{
    default= "roboshop"
}
variable "environment"{
    type=map
# these are the tf workspaces 
    default={
        dev= "dev"
        prod= "prod"
    }
}

variable "instance_type"{
    default="t3.micro"
}

variable "Ec2_tags" {
    type = map
    default={
        Name = "terraform-demo"
        Terraform=true
    }
}

variable "sg_port" {
  type=number
  default=0
  description = "This is to allow all the ports"
}

variable "sg_cidr" {
    type=list
    default=["0.0.0.0/0"]
}
variable "sg_protocol" {
    type=string
    default="-1" # -1 means all protocols
}

