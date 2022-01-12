locals {
  conformance_pack_backup_common_tags = {
    service = "backup"
  }
}

control "backup_plan_min_retention_35_days" {
  title         = "Backup plan min frequency and min retention check"
  description   = "Checks if a backup plan has a backup rule that satisfies the required frequency and retention period(35 Days). The rule is non complaint if recovery points are not created at least as often as the specified frequency or expire before the specified period."
  sql           = query.backup_plan_min_retention_35_days.sql

  tags = local.conformance_pack_backup_common_tags
}
