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

control "backup_plan_min_retention_35_days" {
  title         = "Backup plan min frequency and min retention check"
  description   = "Checks if a backup plan has a backup rule that satisfies the required frequency and retention period(35 Days). The rule is non complaint if recovery points are not created at least as often as the specified frequency or expire before the specified period."
  sql           = query.backup_plan_min_retention_35_days.sql

  tags = local.backup_compliance_common_tags
}