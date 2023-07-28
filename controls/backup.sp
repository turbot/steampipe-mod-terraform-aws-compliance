locals {
  backup_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Backup"
  })
}

benchmark "backup" {
  title       = "Backup"
  description = "This benchmark provides a set of controls that detect Terraform AWS Backup resources deviating from security best practices."

  children = [
    control.backup_plan_min_retention_35_days,
    control.backup_vault_encryption_at_rest_enabled
  ]

  tags = merge(local.backup_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "backup_plan_min_retention_35_days" {
  title       = "Backup plan min frequency and min retention check"
  description = "Checks if a backup plan has a backup rule that satisfies the required frequency and retention period(35 days). The rule is non complaint if recovery points are not created at least as often as the specified frequency or expire before the specified period."
  query       = query.backup_plan_min_retention_35_days

  tags = merge(local.backup_compliance_common_tags, {
    hipaa    = "true"
    nist_csf = "true"
    soc_2    = "true"
  })
}

control "backup_vault_encryption_at_rest_enabled" {
  title       = "Backup vault encryption at rest enabled"
  description = "Checks if AWS Backup vaults have encryption enabled. The rule is non complaint if the vault does not have encryption enabled."
  query       = query.backup_vault_encryption_at_rest_enabled

  tags = local.backup_compliance_common_tags
}