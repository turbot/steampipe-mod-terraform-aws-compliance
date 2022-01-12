locals {
  conformance_pack_docdb_common_tags = {
    service = "docdb"
  }
}

control "docdb_cluster_audit_logs_enabled" {
  title         = "DocDB cluster audit logging should be enabled"
  description   = "Ensure DocDB cluster audit logging is enabled."
  sql           = query.docdb_cluster_audit_logs_enabled.sql

  tags = local.conformance_pack_docdb_common_tags
}