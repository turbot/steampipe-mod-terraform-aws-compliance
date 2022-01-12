locals {
  backup_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "backup"
  })
}

benchmark "backup" {
  title         = "Backup"
  children = [
    control.backup_plan_min_retention_35_days
  ]
  tags          = local.backup_compliance_common_tags
}
