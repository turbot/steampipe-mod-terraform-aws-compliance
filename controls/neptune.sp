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
