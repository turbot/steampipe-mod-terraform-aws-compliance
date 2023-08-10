locals {
  docdb_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/DocumentDB"
  })
}

benchmark "docdb" {
  title       = "DocumentDB"
  description = "This benchmark provides a set of controls that detect Terraform AWS DocumentDB resources deviating from security best practices."

  children = [
    control.docdb_cluster_audit_logs_enabled,
    control.docdb_cluster_encrypted_with_kms,
    control.docdb_global_cluster_encrypted,
    control.docdb_log_exports_enabled,
    control.docdb_paramater_group_with_logging,
    control.docdb_tls_enabled
  ]

  tags = merge(local.docdb_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "docdb_cluster_audit_logs_enabled" {
  title       = "DocDB cluster audit logging should be enabled"
  description = "Ensure DocDB cluster audit logging is enabled."
  query       = query.docdb_cluster_audit_logs_enabled

  tags = local.docdb_compliance_common_tags
}

control "docdb_cluster_encrypted_with_kms" {
  title       = "DocDB cluster should be encrypted using KMS"
  description = "Ensure DocDB clusters being created are set to be encrypted at rest using customer-managed CMK."
  query       = query.docdb_cluster_encrypted_with_kms

  tags = local.docdb_compliance_common_tags
}

control "docdb_global_cluster_encrypted" {
  title       = "DocDB Global Cluster encryption at rest enabled"
  description = "This control checks whether DocDB Global Cluster is enabled with encryption at rest (default is unencrypted)."
  query       = query.docdb_global_cluster_encrypted

  tags = local.docdb_compliance_common_tags
}

control "docdb_log_exports_enabled" {
  title       = "DocDB cluster has log export enabled"
  description = "This control checks whether DocDB cluster log export is enabled."
  query       = query.docdb_log_exports_enabled

  tags = local.docdb_compliance_common_tags
}

control "docdb_paramater_group_with_logging" {
  title       = "DocDB has audit logs enabled"
  description = "This control checks whether DocDB logging is enabled through its parameter group."
  query       = query.docdb_paramater_group_with_logging

  tags = local.docdb_compliance_common_tags
}

control "docdb_tls_enabled" {
  title       = "DocDB TLS should be enabled"
  description = "This control checks whether DocDB TLS is enabled through its parameter group."
  query       = query.docdb_tls_enabled

  tags = local.docdb_compliance_common_tags
}
