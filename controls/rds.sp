locals {
  rds_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "rds"
  })
}

benchmark "rds" {
  title    = "RDS"
  children = [
    control.rds_db_cluster_aurora_backtracking_enabled,
    control.rds_db_cluster_copy_tags_to_snapshot_enabled,
    control.rds_db_cluster_deletion_protection_enabled,
    control.rds_db_cluster_events_subscription,
    control.rds_db_cluster_iam_authentication_enabled,
    control.rds_db_cluster_multiple_az_enabled,
    control.rds_db_instance_and_cluster_enhanced_monitoring_enabled,
    control.rds_db_instance_and_cluster_no_default_port,
    control.rds_db_instance_automatic_minor_version_upgrade_enabled,
    control.rds_db_instance_backup_enabled,
    control.rds_db_instance_copy_tags_to_snapshot_enabled,
    control.rds_db_instance_deletion_protection_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_instance_events_subscription,
    control.rds_db_instance_iam_authentication_enabled,
    control.rds_db_instance_logging_enabled,
    control.rds_db_instance_multiple_az_enabled,
    control.rds_db_instance_prohibit_public_access,
    control.rds_db_parameter_group_events_subscription,
    control.rds_db_security_group_events_subscription
  ]
  tags          = local.rds_compliance_common_tags
}
