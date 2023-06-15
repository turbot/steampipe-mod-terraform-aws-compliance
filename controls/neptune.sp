locals {
  neptune_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Neptune"
  })
}

benchmark "neptune" {
  title       = "Neptune"
  description = "This benchmark provides a set of controls that detect Terraform AWS Neptune resources deviating from security best practices."

  children = [
    control.neptune_cluster_logging_enabled,
    control.neptune_cluster_encryption_at_rest_enabled
  ]

  tags = merge(local.neptune_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "neptune_cluster_logging_enabled" {
  title       = "Neptune logging should be enabled"
  description = "Ensure Neptune logging is enabled. These access logs can be used to analyze traffic patterns and troubleshoot security and operational issues."
  query       = query.neptune_cluster_logging_enabled

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_encryption_at_rest_enabled" {
  title       = "Neptune cluster encryption at rest should be enabled"
  description = "Ensure Neptune clusters being created are set to be encrypted at rest to protect sensitive data."
  query       = query.neptune_cluster_encryption_at_rest_enabled

  tags = local.neptune_compliance_common_tags
}
