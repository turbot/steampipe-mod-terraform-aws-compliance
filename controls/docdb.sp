locals {
  docdb_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "docdb"
  })
}

benchmark "docdb" {
  title       = "DocumentDB"
  description = "This benchmark provides a set of controls that detect Terraform AWS DocumentDB resources deviating from security best practices."

  children = [
    control.docdb_cluster_audit_logs_enabled
  ]

  tags = local.docdb_compliance_common_tags
}

control "docdb_cluster_audit_logs_enabled" {
  title         = "DocDB cluster audit logging should be enabled"
  description   = "Ensure DocDB cluster audit logging is enabled."
  sql           = query.docdb_cluster_audit_logs_enabled.sql

  tags = local.docdb_compliance_common_tags
}