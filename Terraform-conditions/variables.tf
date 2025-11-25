variable "ami-id" {
    default="ami-09c813fb71547fc4f"  
    type= string
}

variable "Ec2_tags" {
    type = map
    default={
        Name = "terraform-demo"
        Terraform=true
        Environment="Dev"
    }
}

variable "sg_name" {
    type = string
    default="allow-all"
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