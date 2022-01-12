locals {
  redshift_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "redshift"
  })
}

benchmark "redshift" {
  title    = "Redshift"
  children = [
    control.redshift_cluster_automatic_snapshots_min_7_days,
    control.redshift_cluster_automatic_upgrade_major_versions_enabled,
    control.redshift_cluster_deployed_in_ec2_classic_mode,
    control.redshift_cluster_encryption_logging_enabled,
    control.redshift_cluster_enhanced_vpc_routing_enabled,
    control.redshift_cluster_kms_enabled,
    control.redshift_cluster_logging_enabled,
    control.redshift_cluster_maintenance_settings_check,
    control.redshift_cluster_prohibit_public_access
  ]
  tags          = local.redshift_compliance_common_tags
}
