locals {
  autoscaling_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/AutoScaling"
  })
}

benchmark "autoscaling" {
  title       = "Auto Scaling"
  description = "This benchmark provides a set of controls that detect Terraform AWS Auto Scaling resources deviating from security best practices."

  children = [
    control.autoscaling_group_tagging_enabled,
    control.autoscaling_group_uses_launch_template,
    control.autoscaling_group_with_lb_use_health_check,
    control.autoscaling_launch_config_public_ip_disabled
  ]

  tags = merge(local.autoscaling_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "autoscaling_group_with_lb_use_health_check" {
  title       = "Auto Scaling groups with a load balancer should use health checks"
  description = "The Elastic Load Balancer (ELB) health checks for Amazon Elastic Compute Cloud (Amazon EC2) Auto Scaling groups that support maintenance of adequate capacity and availability."
  query       = query.autoscaling_group_with_lb_use_health_check

  tags = merge(local.autoscaling_compliance_common_tags, {
    hipaa             = "true"
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
  })
}

control "autoscaling_launch_config_public_ip_disabled" {
  title       = "Auto Scaling launch config public IP should be disabled"
  description = "Ensure if Amazon EC2 Auto Scaling groups have public IP addresses enabled through Launch Configurations. This rule is non complaint if the Launch Configuration for an Auto Scaling group has AssociatePublicIpAddress set to 'true'."
  query       = query.autoscaling_launch_config_public_ip_disabled

  tags = merge(local.autoscaling_compliance_common_tags, {
    rbi_cyber_security = "true"
  })
}

control "autoscaling_group_uses_launch_template" {
  title       = "Auto Scaling groups should use launch templates"
  description = "This control checks whether Amazon EC2 Auto Scaling groups use launch templates."
  query       = query.autoscaling_group_uses_launch_template

  tags = local.autoscaling_compliance_common_tags
}

control "autoscaling_group_tagging_enabled" {
  title       = "Auto Scaling groups should have tagging enabled"
  description = "This control checks whether Amazon EC2 Auto Scaling groups have tagging enabled."
  query       = query.autoscaling_group_tagging_enabled

  tags = local.autoscaling_compliance_common_tags
}
