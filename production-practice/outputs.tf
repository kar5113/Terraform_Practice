output "security_group_id" {
  description = "Application security group ID"
  value       = module.app_stack.security_group_id
}

output "listener_rule_arn" {
  description = "ALB listener rule ARN"
  value       = module.app_stack.listener_rule_arn
}

output "target_group_arns" {
  description = "Target group ARNs created for the service"
  value       = module.app_stack.target_group_arns
}

output "autoscaling_group_names" {
  description = "Auto Scaling group names created for the service"
  value       = module.app_stack.autoscaling_group_names
}
