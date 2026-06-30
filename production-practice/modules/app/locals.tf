locals {
  // Normalize text inputs so comparisons work even if the caller changes case.
  normalized_deployment_type   = lower(var.deployment_type)
  normalized_deployment_action = lower(var.deployment_action)
  normalized_active_target     = lower(var.active_target)

  app_key = lower(var.app_name)

  release_ami_id = local.normalized_deployment_action == "rollback" && var.rollback_ami_id != "" ? var.rollback_ami_id : var.app_ami_id

  secondary_ami_id = var.secondary_ami_id != "" ? var.secondary_ami_id : local.release_ami_id

  secondary_instance_type = var.secondary_instance_type != "" ? var.secondary_instance_type : var.instance_type

  // Rolling uses one stack, canary and blue/green use two tracks.
  use_secondary = local.normalized_deployment_type != "rolling"

  primary_weight   = local.normalized_deployment_type == "canary" ? 90 : (local.normalized_active_target == "primary" ? 100 : 0)
  secondary_weight = local.normalized_deployment_type == "canary" ? 10 : (local.normalized_active_target == "primary" ? 0 : 100)

  secondary_desired_capacity = local.normalized_deployment_type == "canary" ? max(1, ceil(var.desired_capacity / 10)) : var.desired_capacity

  // Build the release map once so the resources below can loop over it.
  release_sets = local.use_secondary ? {
    primary = {
      ami_id           = local.release_ami_id
      instance_type    = var.instance_type
      desired_capacity = var.desired_capacity
      min_size         = var.min_size
      max_size         = var.max_size
      weight           = local.primary_weight
    }
    secondary = {
      ami_id           = local.secondary_ami_id
      instance_type    = local.secondary_instance_type
      desired_capacity = local.secondary_desired_capacity
      min_size         = local.normalized_deployment_type == "canary" ? local.secondary_desired_capacity : var.min_size
      max_size         = local.normalized_deployment_type == "canary" ? max(var.max_size, local.secondary_desired_capacity) : var.max_size
      weight           = local.secondary_weight
    }
    } : {
    primary = {
      ami_id           = local.release_ami_id
      instance_type    = var.instance_type
      desired_capacity = var.desired_capacity
      min_size         = var.min_size
      max_size         = var.max_size
      weight           = 100
    }
  }

  common_tags = merge(
    var.tags,
    {
      Application = var.app_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )

  // Used everywhere to keep naming consistent across resources.
  name_prefix = "${local.app_key}-${var.environment}"
}
