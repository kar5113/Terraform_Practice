variable "aws_region" {
  description = "AWS region for the application stack"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the microservice or frontend component"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "prod"
}

variable "deployment_type" {
  description = "Release pattern to use"
  type        = string

  validation {
    condition     = contains(["rolling", "canary", "bluegreen"], lower(var.deployment_type))
    error_message = "deployment_type must be one of rolling, canary, or bluegreen."
  }
}

variable "deployment_action" {
  description = "What the pipeline is doing right now"
  type        = string
  default     = "deploy"

  validation {
    condition     = contains(["deploy", "update", "rollback"], lower(var.deployment_action))
    error_message = "deployment_action must be one of deploy, update, or rollback."
  }
}

variable "app_ami_id" {
  description = "Current release AMI for the application"
  type        = string
}

variable "rollback_ami_id" {
  description = "Previous release AMI used when deployment_action is rollback"
  type        = string
  default     = ""
}

variable "secondary_ami_id" {
  description = "Optional secondary AMI for canary or blue/green release tracks"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Primary instance type for the service"
  type        = string
  default     = "t3.micro"
}

variable "secondary_instance_type" {
  description = "Optional secondary instance type for the green/canary fleet"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Existing VPC where the app runs"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for the application Auto Scaling group"
  type        = list(string)
}

variable "listener_arn" {
  description = "Existing ALB listener ARN"
  type        = string
}

variable "listener_priority" {
  description = "Priority for the listener rule"
  type        = number
  default     = 100
}

variable "host_header" {
  description = "Host header used for routing the service"
  type        = string
}

variable "container_port" {
  description = "Application port exposed through the target group"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "ALB target group health check path"
  type        = string
  default     = "/health"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the application security group"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to reach the application security group"
  type        = list(string)
  default     = []
}

variable "desired_capacity" {
  description = "Primary Auto Scaling group desired capacity"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Primary Auto Scaling group minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Primary Auto Scaling group maximum size"
  type        = number
  default     = 4
}

variable "active_target" {
  description = "Which target group should receive production traffic in blue/green mode"
  type        = string
  default     = "primary"

  validation {
    condition     = contains(["primary", "secondary"], lower(var.active_target))
    error_message = "active_target must be primary or secondary."
  }
}

variable "enable_stickiness" {
  description = "Enable ALB target group stickiness for canary and blue/green traffic shifts"
  type        = bool
  default     = true
}

variable "sticky_duration_seconds" {
  description = "Stickiness duration when enabled"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Extra tags to apply to all resources"
  type        = map(string)
  default     = {}
}
