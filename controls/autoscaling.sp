locals {
  autoscaling_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "autoscaling"
  })
}

benchmark "autoscaling" {
  title         = "Auto Scaling"
  children = [
    control.autoscaling_group_with_lb_use_health_check,
    control.autoscaling_launch_config_public_ip_disabled
  ]
  tags          = local.autoscaling_compliance_common_tags
}
