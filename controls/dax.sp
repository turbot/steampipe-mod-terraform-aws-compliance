locals {
  dax_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "dax"
  })
}

benchmark "dax" {
  title         = "DAX"
  children = [
    control.dax_cluster_encryption_at_rest_enabled
  ]
  tags          = local.dax_compliance_common_tags
}
