output "security_group_id" {
  description = "Application security group ID"
  value       = aws_security_group.app.id
}

output "listener_rule_arn" {
  description = "Listener rule ARN"
  value       = aws_lb_listener_rule.app.arn
}

output "target_group_arns" {
  description = "Target group ARNs keyed by release track"
  value       = { for key, tg in aws_lb_target_group.release : key => tg.arn }
}

output "autoscaling_group_names" {
  description = "Auto Scaling group names keyed by release track"
  value       = { for key, asg in aws_autoscaling_group.release : key => asg.name }
}

output "launch_template_ids" {
  description = "Launch template IDs keyed by release track"
  value       = { for key, lt in aws_launch_template.release : key => lt.id }
}
