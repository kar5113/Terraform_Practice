// Root module keeps the app release inputs thin and passes them to the reusable app module.
module "app_stack" {
  source = "./modules/app"

  app_name                   = var.app_name
  environment                = var.environment
  deployment_type            = var.deployment_type
  deployment_action          = var.deployment_action
  app_ami_id                 = var.app_ami_id
  rollback_ami_id            = var.rollback_ami_id
  secondary_ami_id           = var.secondary_ami_id
  instance_type              = var.instance_type
  secondary_instance_type    = var.secondary_instance_type
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  listener_arn               = var.listener_arn
  listener_priority          = var.listener_priority
  host_header                = var.host_header
  container_port             = var.container_port
  health_check_path          = var.health_check_path
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids
  desired_capacity           = var.desired_capacity
  min_size                   = var.min_size
  max_size                   = var.max_size
  active_target              = var.active_target
  enable_stickiness          = var.enable_stickiness
  sticky_duration_seconds    = var.sticky_duration_seconds
  tags                       = var.tags
}
