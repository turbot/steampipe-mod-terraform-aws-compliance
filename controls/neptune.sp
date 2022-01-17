locals {
  neptune_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "emr"
  })
}

benchmark "neptune" {
  title    = "Neptune"
  children = [
    control.neptune_cluster_logging_enabled
  ]
  tags          = local.neptune_compliance_common_tags
}

control "neptune_cluster_logging_enabled" {
  title       = "Neptune logging should be enabled"
  description = "Ensure Neptune logging is enabled. These access logs can be used to analyze traffic patterns and troubleshoot security and operational issues."
  sql           = query.neptune_cluster_logging_enabled.sql

  tags = local.neptune_compliance_common_tags
}