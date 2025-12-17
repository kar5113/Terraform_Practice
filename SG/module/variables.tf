variable "sg_name" {
  description = "The name of the security group"
  type        = string
}

variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default=" "
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "sg_tags" {
  description = "A map of tags to assign to the security group"
  type        = map
  default     = {}
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
}