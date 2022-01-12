locals {
  conformance_pack_neptune_common_tags = {
    service = "neptune"
  }
}

control "neptune_cluster_logging_enabled" {
  title       = "Neptune logging should be enabled"
  description = "Ensure Neptune logging is enabled. These access logs can be used to analyze traffic patterns and troubleshoot security and operational issues."
  sql           = query.neptune_cluster_logging_enabled.sql

  tags = local.conformance_pack_neptune_common_tags
}