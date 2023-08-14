locals {
  qldb_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/QLDB"
  })
}

benchmark "qldb" {
  title       = "QLDB"
  description = "This benchmark provides a set of controls that detect Terraform AWS QLDB resources deviating from security best practices."

  children = [
    control.qldb_ledger_deletion_protection_enabled
  ]

  tags = merge(local.qldb_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "qldb_ledger_deletion_protection_enabled" {
  title       = "QLDB ledger should have deletion protection enabled"
  description = "This control checks whether deletion protection is enabled for QLDB ledger."
  query       = query.qldb_ledger_deletion_protection_enabled

  tags = local.qldb_compliance_common_tags
}

control "qldb_ledger_permission_mode_set_to_standard" {
  title       = "QLDB ledger permission mode should be set to 'STANDARD'"
  description = "This control checks whether permission mode is set to 'STANDARD' for QLDB ledger."
  query       = query.qldb_ledger_permission_mode_set_to_standard

  tags = local.qldb_compliance_common_tags
}