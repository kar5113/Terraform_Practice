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

variable "sg_names"{
  default= ["catalogue","cart","user","shipping","payment",
  
            "frontend",
            
            "mongodb","mysql","redis","rabbitmq","bastion",
            
            "frontend_alb", "backend_alb",
            
            "open_VPN"]
}