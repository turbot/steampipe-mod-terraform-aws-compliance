locals {
  ec2_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ec2"
  })
}

benchmark "ec2" {
  title         = "EC2"
  children = [
    control.ec2_classic_lb_connection_draining_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.ec2_instance_detailed_monitoring_enabled,
    control.ec2_instance_ebs_optimized,
    control.ec2_instance_not_publicly_accessible,
    control.ec2_instance_not_use_multiple_enis,
    control.ec2_instance_termination_protection_enabled,
    control.ec2_instance_uses_imdsv2
  ]
  tags          = local.ec2_compliance_common_tags
}
