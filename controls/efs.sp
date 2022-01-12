locals {
  efs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "efs"
  })
}

benchmark "efs" {
  title         = "EFS"
  children = [
    control.efs_file_system_automatic_backups_enabled,
    control.efs_file_system_encrypt_data_at_rest,
  ]
  tags          = local.efs_compliance_common_tags
}
