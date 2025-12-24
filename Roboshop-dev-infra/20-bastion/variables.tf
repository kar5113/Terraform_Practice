variable "project" {
    description = "The name of the project"
    type        = string
    default     = "roboshop"
  
}

variable "environment" {
    description = "The environment for the deployment"
    type        = string
    default     = "dev"
  
}

variable "domain_name" {
    description = "The domain name for Route53 records"
    type        = string
    default="kardev.space"
}