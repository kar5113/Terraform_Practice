variable "project" {
  description = "The name of the project"
  type        = string
  default     = "Roboshop"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "dev"
}

variable "sg_names"{
  default= ["catalogue-sg","cart-sg","user-sg","shipping-sg","payment-sg",
  
            "frontend-sg",
            
            "mongodb-sg","mysql-sg","redis-sg","rabbitmq-sg","bastion-sg",
            
            "frontend-lb-sg"]
}